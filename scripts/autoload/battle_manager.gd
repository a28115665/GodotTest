extends Node
## Manages battle state and logic.

signal battle_ended(result: String)  # "win", "lose", "run", "caught"

# Battle state
var is_battle_active: bool = false
var is_trainer_battle: bool = false
var battle_type: String = "wild"  # "wild" or "trainer"

# Combatants
var player_pokemon = null  # Current active PokemonInstance
var enemy_pokemon = null   # Current active enemy PokemonInstance
var player_party_index: int = 0

# Trainer info (for trainer battles)
var trainer_name: String = ""
var trainer_party: Array = []
var trainer_party_index: int = 0
var trainer_defeated_flag: String = ""

# Turn state
var player_action: Dictionary = {}
var enemy_action: Dictionary = {}

func start_wild_battle(wild_pokemon) -> void:
	is_battle_active = true
	is_trainer_battle = false
	battle_type = "wild"
	enemy_pokemon = wild_pokemon
	player_party_index = _get_first_alive_index()
	player_pokemon = GameData.party[player_party_index]
	GameData.add_to_seen(wild_pokemon.species_id)

func start_trainer_battle(t_name: String, t_party: Array) -> void:
	is_battle_active = true
	is_trainer_battle = true
	battle_type = "trainer"
	trainer_name = t_name
	trainer_party = t_party
	trainer_party_index = 0
	enemy_pokemon = trainer_party[0]
	player_party_index = _get_first_alive_index()
	player_pokemon = GameData.party[player_party_index]

func calculate_damage(attacker, defender, move: Dictionary) -> int:
	if move["category"] == "status":
		return 0

	var level = attacker.level
	var attack_stat: float
	var defense_stat: float

	if move["category"] == "physical":
		attack_stat = attacker.get_attack()
		defense_stat = defender.get_defense()
	else:
		attack_stat = attacker.get_sp_attack()
		defense_stat = defender.get_sp_defense()

	var power = move["power"]

	# Base damage formula (Gen I style)
	var damage = ((2.0 * level / 5.0 + 2.0) * power * attack_stat / defense_stat) / 50.0 + 2.0

	# STAB (Same Type Attack Bonus)
	var species = PokemonDatabase.get_species(attacker.species_id)
	if species and move["type"] in species["types"]:
		damage *= 1.5

	# Type effectiveness
	var effectiveness = _get_type_effectiveness(move["type"], defender.species_id)
	damage *= effectiveness

	# Random factor (85-100%)
	damage *= randf_range(0.85, 1.0)

	return max(1, int(damage))

func _get_type_effectiveness(attack_type: String, defender_id: int) -> float:
	var defender_species = PokemonDatabase.get_species(defender_id)
	if not defender_species:
		return 1.0

	var effectiveness = 1.0
	for def_type in defender_species["types"]:
		effectiveness *= TypeChart.get_effectiveness(attack_type, def_type)
	return effectiveness

func get_effectiveness_text(attack_type: String, defender_id: int) -> String:
	var eff = _get_type_effectiveness(attack_type, defender_id)
	if eff > 1.5:
		return "super_effective"
	elif eff < 0.5:
		if eff == 0.0:
			return "no_effect"
		return "not_effective"
	elif eff > 1.0:
		return "super_effective"
	elif eff < 1.0:
		return "not_effective"
	return "normal"

func try_catch(pokemon, ball_type: String = "pokeball") -> bool:
	if is_trainer_battle:
		return false

	var catch_rate = PokemonDatabase.get_species(pokemon.species_id).get("catch_rate", 45)
	var hp_factor = (3.0 * pokemon.max_hp - 2.0 * pokemon.current_hp) / (3.0 * pokemon.max_hp)
	var ball_bonus = 1.0
	if ball_type == "greatball":
		ball_bonus = 1.5
	elif ball_type == "ultraball":
		ball_bonus = 2.0
	elif ball_type == "masterball":
		return true

	var catch_chance = (catch_rate * hp_factor * ball_bonus) / 255.0
	return randf() < catch_chance

func try_run() -> bool:
	if is_trainer_battle:
		return false
	var player_speed = player_pokemon.get_speed()
	var enemy_speed = enemy_pokemon.get_speed()
	if player_speed >= enemy_speed:
		return true
	var run_chance = (player_speed * 128.0 / enemy_speed + 30.0) / 256.0
	return randf() < run_chance

func get_exp_yield(defeated_pokemon) -> int:
	var base_exp = PokemonDatabase.get_species(defeated_pokemon.species_id).get("base_exp", 64)
	var level = defeated_pokemon.level
	var is_wild = not is_trainer_battle
	var trainer_mult = 1.0 if is_wild else 1.5
	return int(base_exp * level * trainer_mult / 7.0)

func check_player_party_alive() -> bool:
	for pokemon in GameData.party:
		if pokemon.current_hp > 0:
			return true
	return false

func _get_first_alive_index() -> int:
	for i in range(GameData.party.size()):
		if GameData.party[i].current_hp > 0:
			return i
	return 0

func get_enemy_move() -> Dictionary:
	# Simple AI: pick a random move
	var available_moves = []
	for move in enemy_pokemon.moves:
		if move["current_pp"] > 0:
			available_moves.append(move)
	if available_moves.is_empty():
		# Struggle
		return {"name": "Struggle", "type": "normal", "power": 50, "accuracy": 100, "pp": 1, "max_pp": 1, "current_pp": 1, "category": "physical"}
	return available_moves[randi() % available_moves.size()]

func end_battle(result: String) -> void:
	is_battle_active = false
	battle_ended.emit(result)

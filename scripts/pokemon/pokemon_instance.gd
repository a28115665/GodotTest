class_name PokemonInstance
extends RefCounted
## Represents a single Pokemon instance with individual stats and state.

var species_id: int = 1
var nickname: String = ""
var level: int = 5
var current_hp: int = 20
var max_hp: int = 20
var status: String = ""  # "", "poison", "burn", "sleep", "paralyze", "freeze"

# IVs (0-15 in Gen I)
var iv_hp: int = 8
var iv_attack: int = 8
var iv_defense: int = 8
var iv_sp_attack: int = 8
var iv_sp_defense: int = 8
var iv_speed: int = 8

# EVs
var ev_hp: int = 0
var ev_attack: int = 0
var ev_defense: int = 0
var ev_sp_attack: int = 0
var ev_sp_defense: int = 0
var ev_speed: int = 0

# Experience
var exp: int = 0
var exp_to_next_level: int = 0

# Moves (max 4)
var moves: Array = []  # Array of move dictionaries

# OT info
var ot_name: String = "RED"
var ot_id: int = 0

func _init() -> void:
	pass

static func create(id: int, lv: int, nick: String = "") -> PokemonInstance:
	var pokemon = PokemonInstance.new()
	pokemon.species_id = id
	pokemon.level = lv
	pokemon.nickname = nick

	# Randomize IVs
	pokemon.iv_hp = randi() % 16
	pokemon.iv_attack = randi() % 16
	pokemon.iv_defense = randi() % 16
	pokemon.iv_sp_attack = randi() % 16
	pokemon.iv_sp_defense = randi() % 16
	pokemon.iv_speed = randi() % 16

	# Calculate stats
	pokemon._calculate_stats()

	# Set moves based on level
	pokemon._set_level_moves()

	pokemon.current_hp = pokemon.max_hp
	pokemon.exp_to_next_level = pokemon._calculate_exp_for_level(lv + 1)

	return pokemon

func get_display_name() -> String:
	if nickname != "":
		return nickname
	var species = PokemonDatabase.get_species(species_id)
	if species:
		return species["name"]
	return "???"

func _calculate_stats() -> void:
	var species = PokemonDatabase.get_species(species_id)
	if not species:
		return

	var base = species["base_stats"]
	max_hp = _calc_hp_stat(base["hp"], iv_hp, ev_hp)
	exp_to_next_level = _calculate_exp_for_level(level + 1)

func _calc_hp_stat(base: int, iv: int, ev: int) -> int:
	return int(((2 * base + iv + ev / 4.0) * level) / 100.0) + level + 10

func _calc_stat(base: int, iv: int, ev: int) -> int:
	return int(((2 * base + iv + ev / 4.0) * level) / 100.0) + 5

func get_attack() -> int:
	var species = PokemonDatabase.get_species(species_id)
	if not species:
		return 10
	return _calc_stat(species["base_stats"]["attack"], iv_attack, ev_attack)

func get_defense() -> int:
	var species = PokemonDatabase.get_species(species_id)
	if not species:
		return 10
	return _calc_stat(species["base_stats"]["defense"], iv_defense, ev_defense)

func get_sp_attack() -> int:
	var species = PokemonDatabase.get_species(species_id)
	if not species:
		return 10
	return _calc_stat(species["base_stats"]["sp_attack"], iv_sp_attack, ev_sp_attack)

func get_sp_defense() -> int:
	var species = PokemonDatabase.get_species(species_id)
	if not species:
		return 10
	return _calc_stat(species["base_stats"]["sp_defense"], iv_sp_defense, ev_sp_defense)

func get_speed() -> int:
	var species = PokemonDatabase.get_species(species_id)
	if not species:
		return 10
	return _calc_stat(species["base_stats"]["speed"], iv_speed, ev_speed)

func _set_level_moves() -> void:
	moves.clear()
	var species = PokemonDatabase.get_species(species_id)
	if not species:
		return

	var learnable = species.get("learnset", [])
	var learned = []
	for entry in learnable:
		if entry["level"] <= level:
			learned.append(entry)

	# Take last 4 moves learned
	var start_idx = max(0, learned.size() - 4)
	for i in range(start_idx, learned.size()):
		var move_data = MoveDatabase.get_move(learned[i]["move"])
		if move_data:
			var move = move_data.duplicate()
			move["current_pp"] = move["pp"]
			move["max_pp"] = move["pp"]
			moves.append(move)

func add_exp(amount: int) -> Dictionary:
	var result = {"leveled_up": false, "new_level": level, "new_moves": []}
	exp += amount

	while exp >= exp_to_next_level and level < 100:
		level += 1
		var old_max_hp = max_hp
		_calculate_stats()
		current_hp += max_hp - old_max_hp
		exp_to_next_level = _calculate_exp_for_level(level + 1)
		result["leveled_up"] = true
		result["new_level"] = level

		# Check for new moves
		var species = PokemonDatabase.get_species(species_id)
		if species:
			for entry in species.get("learnset", []):
				if entry["level"] == level:
					result["new_moves"].append(entry["move"])

	return result

func learn_move(move_name: String) -> bool:
	var move_data = MoveDatabase.get_move(move_name)
	if not move_data:
		return false

	var move = move_data.duplicate()
	move["current_pp"] = move["pp"]
	move["max_pp"] = move["pp"]

	if moves.size() < 4:
		moves.append(move)
		return true
	return false

func replace_move(index: int, move_name: String) -> bool:
	if index < 0 or index >= moves.size():
		return false
	var move_data = MoveDatabase.get_move(move_name)
	if not move_data:
		return false

	var move = move_data.duplicate()
	move["current_pp"] = move["pp"]
	move["max_pp"] = move["pp"]
	moves[index] = move
	return true

func _calculate_exp_for_level(lv: int) -> int:
	# Medium Fast growth rate
	return lv * lv * lv

func take_damage(amount: int) -> void:
	current_hp = max(0, current_hp - amount)

func heal(amount: int) -> void:
	current_hp = min(max_hp, current_hp + amount)

func is_fainted() -> bool:
	return current_hp <= 0

func serialize() -> Dictionary:
	return {
		"species_id": species_id,
		"nickname": nickname,
		"level": level,
		"current_hp": current_hp,
		"max_hp": max_hp,
		"status": status,
		"iv_hp": iv_hp, "iv_attack": iv_attack, "iv_defense": iv_defense,
		"iv_sp_attack": iv_sp_attack, "iv_sp_defense": iv_sp_defense, "iv_speed": iv_speed,
		"ev_hp": ev_hp, "ev_attack": ev_attack, "ev_defense": ev_defense,
		"ev_sp_attack": ev_sp_attack, "ev_sp_defense": ev_sp_defense, "ev_speed": ev_speed,
		"exp": exp,
		"moves": moves,
		"ot_name": ot_name,
	}

func deserialize(data: Dictionary) -> void:
	species_id = data.get("species_id", 1)
	nickname = data.get("nickname", "")
	level = data.get("level", 5)
	current_hp = data.get("current_hp", 20)
	max_hp = data.get("max_hp", 20)
	status = data.get("status", "")
	iv_hp = data.get("iv_hp", 8)
	iv_attack = data.get("iv_attack", 8)
	iv_defense = data.get("iv_defense", 8)
	iv_sp_attack = data.get("iv_sp_attack", 8)
	iv_sp_defense = data.get("iv_sp_defense", 8)
	iv_speed = data.get("iv_speed", 8)
	ev_hp = data.get("ev_hp", 0)
	ev_attack = data.get("ev_attack", 0)
	ev_defense = data.get("ev_defense", 0)
	ev_sp_attack = data.get("ev_sp_attack", 0)
	ev_sp_defense = data.get("ev_sp_defense", 0)
	ev_speed = data.get("ev_speed", 0)
	exp = data.get("exp", 0)
	moves = data.get("moves", [])
	ot_name = data.get("ot_name", "RED")
	_calculate_stats()

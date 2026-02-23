extends Node
## Global game data singleton - manages player state, party, inventory, and save/load.

# Player info
var player_name: String = "RED"
var rival_name: String = "BLUE"
var money: int = 3000
var badges: Array[bool] = [false, false, false, false, false, false, false, false]
var play_time: float = 0.0

# Party and PC
var party: Array = []  # Array of PokemonInstance
var pc_pokemon: Array = []

# Inventory
var inventory: Dictionary = {
	"potion": 5,
	"pokeball": 10,
	"antidote": 2,
}

# Game progress flags
var flags: Dictionary = {
	"got_starter": false,
	"got_pokedex": false,
	"rival_defeated_1": false,
}

# Current map info
var current_map: String = "pallet_town"
var player_position: Vector2 = Vector2(5, 5)
var player_direction: String = "down"

# Pokedex
var pokedex_seen: Array[int] = []
var pokedex_caught: Array[int] = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	play_time += delta

func add_pokemon_to_party(pokemon) -> bool:
	if party.size() < 6:
		party.append(pokemon)
		if pokemon.species_id not in pokedex_caught:
			pokedex_caught.append(pokemon.species_id)
		if pokemon.species_id not in pokedex_seen:
			pokedex_seen.append(pokemon.species_id)
		return true
	else:
		pc_pokemon.append(pokemon)
		return false

func add_to_seen(species_id: int) -> void:
	if species_id not in pokedex_seen:
		pokedex_seen.append(species_id)

func heal_party() -> void:
	for pokemon in party:
		pokemon.current_hp = pokemon.max_hp
		pokemon.status = ""
		for move in pokemon.moves:
			move["current_pp"] = move["max_pp"]

func add_item(item_name: String, count: int = 1) -> void:
	if item_name in inventory:
		inventory[item_name] += count
	else:
		inventory[item_name] = count

func remove_item(item_name: String, count: int = 1) -> bool:
	if item_name in inventory and inventory[item_name] >= count:
		inventory[item_name] -= count
		if inventory[item_name] <= 0:
			inventory.erase(item_name)
		return true
	return false

func has_item(item_name: String, count: int = 1) -> bool:
	return item_name in inventory and inventory[item_name] >= count

func set_flag(flag_name: String, value: bool = true) -> void:
	flags[flag_name] = value

func get_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)

func save_game() -> void:
	var save_data = {
		"player_name": player_name,
		"rival_name": rival_name,
		"money": money,
		"badges": badges,
		"play_time": play_time,
		"party": _serialize_party(),
		"inventory": inventory,
		"flags": flags,
		"current_map": current_map,
		"player_position": {"x": player_position.x, "y": player_position.y},
		"player_direction": player_direction,
		"pokedex_seen": pokedex_seen,
		"pokedex_caught": pokedex_caught,
	}
	var file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_game() -> bool:
	if not FileAccess.file_exists("user://savegame.dat"):
		return false
	var file = FileAccess.open("user://savegame.dat", FileAccess.READ)
	var save_data = file.get_var()
	file.close()
	if save_data == null:
		return false
	player_name = save_data.get("player_name", "RED")
	rival_name = save_data.get("rival_name", "BLUE")
	money = save_data.get("money", 3000)
	badges = save_data.get("badges", [false, false, false, false, false, false, false, false])
	play_time = save_data.get("play_time", 0.0)
	inventory = save_data.get("inventory", {})
	flags = save_data.get("flags", {})
	current_map = save_data.get("current_map", "pallet_town")
	var pos = save_data.get("player_position", {"x": 5, "y": 5})
	player_position = Vector2(pos["x"], pos["y"])
	player_direction = save_data.get("player_direction", "down")
	pokedex_seen = save_data.get("pokedex_seen", [])
	pokedex_caught = save_data.get("pokedex_caught", [])
	_deserialize_party(save_data.get("party", []))
	return true

func _serialize_party() -> Array:
	var result = []
	for pokemon in party:
		result.append(pokemon.serialize())
	return result

func _deserialize_party(data: Array) -> void:
	party.clear()
	for pdata in data:
		var pokemon = PokemonInstance.new()
		pokemon.deserialize(pdata)
		party.append(pokemon)

func has_save() -> bool:
	return FileAccess.file_exists("user://savegame.dat")

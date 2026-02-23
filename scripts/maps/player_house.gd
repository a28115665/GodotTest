extends "res://scripts/maps/base_map.gd"
## Player's house interior.

func _define_map() -> void:
	map_width = 8
	map_height = 8

	var layout = [
		"wwwwwwww",
		"wFFFFFFw",
		"wFFFFFFw",
		"wFFFFFFw",
		"wFFFFFFw",
		"wFFFFFFw",
		"wFFFFFdw",
		"wwwwwwww",
	]

	map_data = []
	var char_to_tile = {
		"w": "wall", "F": "floor", "d": "door",
	}

	for row_str in layout:
		var row = []
		for ch in row_str:
			row.append(char_to_tile.get(ch, "floor"))
		map_data.append(row)

func _spawn_npcs() -> void:
	create_npc("Mom", "nurse", Vector2(2, 3),
		["MOM: Oh, you're heading out?", "Be careful out there!", "Your Pikachu looks so happy\nwith you!"] as Array[String])

func get_warps() -> Array:
	return [
		{"position": Vector2(6, 6), "target_map": "pallet_town", "target_position": Vector2(5, 4)},
	]

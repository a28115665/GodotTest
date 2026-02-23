extends "res://scripts/maps/base_map.gd"
## Route 1 - first route connecting Pallet Town to Viridian City.

func _define_map() -> void:
	map_width = 15
	map_height = 30

	var layout = [
		"ttttttttttttttt",  # 0 (entry from Viridian)
		"tgggGGpGGgggggt",  # 1
		"tgggGGpGGgggggt",  # 2
		"tgggGGpGGgGGggt",  # 3
		"tgggggpgggGGggt",  # 4
		"tggGGgpgggGGggt",  # 5
		"tggGGgpgggggggt",  # 6
		"tgggggpppgggggt",  # 7
		"tttgggggpgggggt",  # 8
		"tgggggggpggGGgt",  # 9
		"tggGGgggpggGGgt",  # 10
		"tggGGgggpgggggt",  # 11
		"tggGGgppppggggt",  # 12
		"tgggggpgggGGggt",  # 13
		"tgggGGpgggGGggt",  # 14
		"tgggGGpgggggggt",  # 15
		"tgggggpgggggggt",  # 16
		"tgggggpppgGGggt",  # 17
		"tggGGgggpgGGggt",  # 18
		"tggGGgggpgggggt",  # 19
		"tgggggggpgggggt",  # 20
		"tttggggppgggggt",  # 21
		"tgggggppgggGGgt",  # 22
		"tgggGGpggggGGgt",  # 23
		"tgggGGpgggggggt",  # 24
		"tgggggpgggggggt",  # 25
		"tgggggpppgggggt",  # 26
		"tggGGgggpgggggt",  # 27
		"tggGGgggpgggggt",  # 28
		"tttttttpptttttt",  # 29 (exit to Pallet)
	]

	map_data = []
	var char_to_tile = {
		"g": "grass", "G": "tall_grass", "p": "path", "w": "wall",
		"t": "tree", "W": "water",
	}

	for row_str in layout:
		var row = []
		for ch in row_str:
			row.append(char_to_tile.get(ch, "grass"))
		map_data.append(row)

func _spawn_npcs() -> void:
	create_npc("Youngster", "trainer", Vector2(6, 15),
		["I just caught a RATTATA!\nWant to see it?", "Catching POKEMON is so much fun!"] as Array[String])

func get_encounter_table() -> Array:
	return [
		{"id": 16, "level": 2},  # Pidgey
		{"id": 16, "level": 3},
		{"id": 16, "level": 4},
		{"id": 19, "level": 2},  # Rattata
		{"id": 19, "level": 3},
		{"id": 19, "level": 4},
	]

func get_warps() -> Array:
	return [
		# South exit -> Pallet Town
		{"position": Vector2(7, 29), "target_map": "pallet_town", "target_position": Vector2(8, 1)},
		{"position": Vector2(8, 29), "target_map": "pallet_town", "target_position": Vector2(9, 1)},
		# North exit -> Viridian City
		{"position": Vector2(6, 0), "target_map": "viridian_city", "target_position": Vector2(9, 17)},
	]

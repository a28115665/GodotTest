extends "res://scripts/maps/base_map.gd"
## Viridian City - first city with a Pokemon Center and Gym.

func _define_map() -> void:
	map_width = 20
	map_height = 20

	var layout = [
		"tttttttttttttttttttt",  # 0
		"tggggggggggggggggggt",  # 1
		"tgrrrrggggrrrrrrgggt",  # 2
		"tgwddwggggwddddwgGGt",  # 3 (Gym left, PokéCenter right)
		"tggppgggggggppgggGGt",  # 4
		"tggppgggggggppgggGGt",  # 5
		"tggpppppppppppgggggt",  # 6
		"tggpppppppppppgggggt",  # 7
		"tggggppggggppggggggt",  # 8
		"tggsgppggsgppggggggt",  # 9
		"tggggppggggppgggGGgt",  # 10
		"tggggppggggppgggGGgt",  # 11
		"tggggppppppppggggGGt",  # 12
		"tggggppppppppggggggt",  # 13
		"tggGGggppggggggggWWt",  # 14
		"tggGGggppggggggggWWt",  # 15
		"tggGGggppggggggggWWt",  # 16
		"ttttttttpptttttttttt",  # 17 (south to Route 1)
		"tttttttttttttttttttt",  # 18
		"tttttttttttttttttttt",  # 19
	]

	map_data = []
	var char_to_tile = {
		"g": "grass", "G": "tall_grass", "p": "path", "w": "wall",
		"t": "tree", "W": "water", "r": "roof", "d": "door", "s": "sign",
	}

	for row_str in layout:
		var row = []
		for ch in row_str:
			row.append(char_to_tile.get(ch, "grass"))
		map_data.append(row)

func _spawn_npcs() -> void:
	create_npc("Nurse Joy", "nurse", Vector2(12, 5),
		["Welcome to the Pokemon Center!", "We'll heal your Pokemon to\nfull health!", "Your Pokemon have been healed!\nWe hope to see you again!"] as Array[String])

	create_npc("Old Man", "trainer", Vector2(5, 8),
		["I've had my coffee now so\nI'm fine!", "When I was young, POKEMON were\neverywhere!", "You can catch them in tall\ngrass with POKE BALLS!"] as Array[String])

	create_npc("Bug Catcher", "trainer", Vector2(15, 10),
		["There are lots of bugs in\nViridian Forest to the west!", "Have you been there?"] as Array[String])

func get_encounter_table() -> Array:
	return [
		{"id": 16, "level": 4},  # Pidgey
		{"id": 16, "level": 5},
		{"id": 19, "level": 3},  # Rattata
		{"id": 19, "level": 5},
		{"id": 56, "level": 4},  # Mankey
	]

func get_warps() -> Array:
	return [
		# South exit -> Route 1
		{"position": Vector2(8, 17), "target_map": "route_1", "target_position": Vector2(6, 1)},
		{"position": Vector2(9, 17), "target_map": "route_1", "target_position": Vector2(7, 1)},
	]

func get_sign_text(tile_pos: Vector2) -> String:
	if tile_pos == Vector2(3, 9):
		return "VIRIDIAN CITY GYM\nGYM LEADER: ???\nThe gym is closed."
	elif tile_pos == Vector2(11, 9):
		return "VIRIDIAN CITY\nPOKEMON CENTER\nHeal your Pokemon here!"
	return ""

extends "res://scripts/maps/base_map.gd"
## Pallet Town - the starting town.

func _define_map() -> void:
	map_width = 20
	map_height = 18

	# Legend:
	# g = grass, G = tall_grass, p = path, w = wall, t = tree
	# W = water, f = fence, r = roof, d = door, s = sign, F = floor
	var layout = [
		"tttttttttttttttttttt",  # 0
		"tggggggggggggggggggt",  # 1
		"tggrrrrggggrrrrggGGt",  # 2
		"tggwddwggggwddwggGGt",  # 3
		"tgggppggggggppgggGGt",  # 4
		"tgggppggggggppgggGGt",  # 5
		"tgggppppppppppgggggt",  # 6
		"tgggppppppppppgggggt",  # 7
		"tggggppggggppggggggt",  # 8
		"tggsgppggsgppgGGGggt",  # 9
		"tggggppggggppgGGGggt",  # 10
		"tggggppggggppgGGGggt",  # 11
		"tggggppppppppggggwwt",  # 12
		"tggggppppppppggggwwt",  # 13
		"tggggggppggggggggwwt",  # 14
		"tGGGgggppgggggggwwt",  # 15
		"tGGGgggppgggggggWWt",  # 16
		"ttttttttpptttttttttt",  # 17
	]

	map_data = []
	var char_to_tile = {
		"g": "grass", "G": "tall_grass", "p": "path", "w": "wall",
		"t": "tree", "W": "water", "f": "fence", "r": "roof",
		"d": "door", "s": "sign", "F": "floor",
	}

	for row_str in layout:
		var row = []
		for ch in row_str:
			row.append(char_to_tile.get(ch, "grass"))
		map_data.append(row)

func _spawn_npcs() -> void:
	# Professor Oak's lab is the right building
	create_npc("Mom", "nurse", Vector2(4, 5),
		["MOM: Good morning, dear!", "Have a great adventure!", "Don't forget to call!"] as Array[String])

	create_npc("Prof. Oak", "professor", Vector2(13, 5),
		["OAK: Hello there! Welcome to the\nworld of POKEMON!", "My name is OAK! People call me\nthe POKEMON PROF!", "This world is inhabited by\ncreatures called POKEMON!", "Your very own POKEMON legend is\nabout to unfold!"] as Array[String])

	create_npc("Rival", "rival", Vector2(11, 8),
		["BLUE: Hey! Gramps isn't here.\nI'm gonna get my POKEMON first!", "Smell ya later!"] as Array[String])

func get_encounter_table() -> Array:
	return [
		{"id": 16, "level": 3},  # Pidgey
		{"id": 16, "level": 4},
		{"id": 19, "level": 2},  # Rattata
		{"id": 19, "level": 3},
		{"id": 19, "level": 4},
	]

func get_warps() -> Array:
	return [
		# Go to Route 1 (south exit)
		{"position": Vector2(8, 17), "target_map": "route_1", "target_position": Vector2(5, 1)},
		{"position": Vector2(9, 17), "target_map": "route_1", "target_position": Vector2(6, 1)},
		# Player house door
		{"position": Vector2(4, 3), "target_map": "player_house", "target_position": Vector2(3, 6)},
		{"position": Vector2(5, 3), "target_map": "player_house", "target_position": Vector2(4, 6)},
		# Oak's Lab door
		{"position": Vector2(12, 3), "target_map": "oak_lab", "target_position": Vector2(4, 10)},
		{"position": Vector2(13, 3), "target_map": "oak_lab", "target_position": Vector2(5, 10)},
	]

func get_sign_text(tile_pos: Vector2) -> String:
	if tile_pos == Vector2(3, 9):
		return "RED's House"
	elif tile_pos == Vector2(11, 9):
		return "OAK Pokemon Research Lab"
	return ""

extends "res://scripts/maps/base_map.gd"
## Professor Oak's Laboratory.

func _define_map() -> void:
	map_width = 10
	map_height = 12

	var layout = [
		"wwwwwwwwww",
		"wFFFFFFFFw",
		"wFFFFFFFFw",
		"wFFFFFFFFw",
		"wFFFFFFFFw",
		"wFFFFFFFFw",
		"wFFFFFFFFw",
		"wFFFFFFFFw",
		"wFFFFFFFFw",
		"wFFFFFFFFw",
		"wFFFFdFFFw",
		"wwwwwwwwww",
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
	create_npc("Prof. Oak", "professor", Vector2(5, 2),
		["OAK: Ah, welcome to my lab!", "I study POKEMON as a profession.", "First, tell me, are you a\nboy or a girl?", "...Just kidding! I can see\nyou're RED!", "Your PIKACHU seems to have\ntaken a liking to you!", "Why don't you go explore\nRoute 1 to the north?"] as Array[String])

	create_npc("Aide", "trainer", Vector2(2, 5),
		["I'm Prof. Oak's aide.", "We research POKEMON here at\nthis lab.", "There are 150 known species\nof POKEMON!"] as Array[String])

func get_warps() -> Array:
	return [
		{"position": Vector2(5, 10), "target_map": "pallet_town", "target_position": Vector2(13, 4)},
	]

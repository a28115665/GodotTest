class_name PokemonDatabase
extends RefCounted
## Static database of all Pokemon species data.

# Species data: base stats, types, learnsets, evolution, etc.
static var species_data: Dictionary = {
	# -- Starter line --
	25: {
		"name": "Pikachu",
		"types": ["electric"],
		"base_stats": {"hp": 35, "attack": 55, "defense": 40, "sp_attack": 50, "sp_defense": 50, "speed": 90},
		"base_exp": 112,
		"catch_rate": 190,
		"learnset": [
			{"level": 1, "move": "thunder_shock"},
			{"level": 1, "move": "growl"},
			{"level": 6, "move": "tail_whip"},
			{"level": 8, "move": "thunder_wave"},
			{"level": 11, "move": "quick_attack"},
			{"level": 15, "move": "double_kick"},
			{"level": 20, "move": "slam"},
			{"level": 26, "move": "thunderbolt"},
		],
		"evolution": {"to": 26, "method": "item", "item": "thunder_stone"},
	},
	26: {
		"name": "Raichu",
		"types": ["electric"],
		"base_stats": {"hp": 60, "attack": 90, "defense": 55, "sp_attack": 90, "sp_defense": 80, "speed": 110},
		"base_exp": 218,
		"catch_rate": 75,
		"learnset": [
			{"level": 1, "move": "thunder_shock"},
			{"level": 1, "move": "tail_whip"},
			{"level": 1, "move": "quick_attack"},
			{"level": 1, "move": "thunderbolt"},
		],
	},
	# -- Bulbasaur line --
	1: {
		"name": "Bulbasaur",
		"types": ["grass", "poison"],
		"base_stats": {"hp": 45, "attack": 49, "defense": 49, "sp_attack": 65, "sp_defense": 65, "speed": 45},
		"base_exp": 64,
		"catch_rate": 45,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 1, "move": "growl"},
			{"level": 7, "move": "leech_seed"},
			{"level": 13, "move": "vine_whip"},
			{"level": 20, "move": "razor_leaf"},
		],
		"evolution": {"to": 2, "method": "level", "level": 16},
	},
	2: {
		"name": "Ivysaur",
		"types": ["grass", "poison"],
		"base_stats": {"hp": 60, "attack": 62, "defense": 63, "sp_attack": 80, "sp_defense": 80, "speed": 60},
		"base_exp": 142,
		"catch_rate": 45,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 1, "move": "growl"},
			{"level": 7, "move": "leech_seed"},
			{"level": 13, "move": "vine_whip"},
			{"level": 22, "move": "razor_leaf"},
		],
		"evolution": {"to": 3, "method": "level", "level": 32},
	},
	3: {
		"name": "Venusaur",
		"types": ["grass", "poison"],
		"base_stats": {"hp": 80, "attack": 82, "defense": 83, "sp_attack": 100, "sp_defense": 100, "speed": 80},
		"base_exp": 236,
		"catch_rate": 45,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 1, "move": "growl"},
			{"level": 7, "move": "leech_seed"},
			{"level": 13, "move": "vine_whip"},
			{"level": 22, "move": "razor_leaf"},
			{"level": 32, "move": "solar_beam"},
		],
	},
	# -- Charmander line --
	4: {
		"name": "Charmander",
		"types": ["fire"],
		"base_stats": {"hp": 39, "attack": 52, "defense": 43, "sp_attack": 60, "sp_defense": 50, "speed": 65},
		"base_exp": 62,
		"catch_rate": 45,
		"learnset": [
			{"level": 1, "move": "scratch"},
			{"level": 1, "move": "growl"},
			{"level": 9, "move": "ember"},
			{"level": 15, "move": "leer"},
			{"level": 22, "move": "slash"},
			{"level": 30, "move": "flamethrower"},
		],
		"evolution": {"to": 5, "method": "level", "level": 16},
	},
	5: {
		"name": "Charmeleon",
		"types": ["fire"],
		"base_stats": {"hp": 58, "attack": 64, "defense": 58, "sp_attack": 80, "sp_defense": 65, "speed": 80},
		"base_exp": 142,
		"catch_rate": 45,
		"learnset": [
			{"level": 1, "move": "scratch"},
			{"level": 1, "move": "growl"},
			{"level": 9, "move": "ember"},
			{"level": 24, "move": "slash"},
			{"level": 33, "move": "flamethrower"},
		],
		"evolution": {"to": 6, "method": "level", "level": 36},
	},
	6: {
		"name": "Charizard",
		"types": ["fire", "flying"],
		"base_stats": {"hp": 78, "attack": 84, "defense": 78, "sp_attack": 109, "sp_defense": 85, "speed": 100},
		"base_exp": 240,
		"catch_rate": 45,
		"learnset": [
			{"level": 1, "move": "scratch"},
			{"level": 1, "move": "ember"},
			{"level": 24, "move": "slash"},
			{"level": 36, "move": "flamethrower"},
			{"level": 46, "move": "fire_blast"},
		],
	},
	# -- Squirtle line --
	7: {
		"name": "Squirtle",
		"types": ["water"],
		"base_stats": {"hp": 44, "attack": 48, "defense": 65, "sp_attack": 50, "sp_defense": 64, "speed": 43},
		"base_exp": 63,
		"catch_rate": 45,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 1, "move": "tail_whip"},
			{"level": 8, "move": "water_gun"},
			{"level": 15, "move": "bite"},
			{"level": 22, "move": "water_pulse"},
		],
		"evolution": {"to": 8, "method": "level", "level": 16},
	},
	8: {
		"name": "Wartortle",
		"types": ["water"],
		"base_stats": {"hp": 59, "attack": 63, "defense": 80, "sp_attack": 65, "sp_defense": 80, "speed": 58},
		"base_exp": 142,
		"catch_rate": 45,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 1, "move": "tail_whip"},
			{"level": 8, "move": "water_gun"},
			{"level": 15, "move": "bite"},
			{"level": 25, "move": "water_pulse"},
		],
		"evolution": {"to": 9, "method": "level", "level": 36},
	},
	9: {
		"name": "Blastoise",
		"types": ["water"],
		"base_stats": {"hp": 79, "attack": 83, "defense": 100, "sp_attack": 85, "sp_defense": 105, "speed": 78},
		"base_exp": 239,
		"catch_rate": 45,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 1, "move": "water_gun"},
			{"level": 25, "move": "water_pulse"},
			{"level": 36, "move": "hydro_pump"},
		],
	},
	# -- Pidgey line --
	16: {
		"name": "Pidgey",
		"types": ["normal", "flying"],
		"base_stats": {"hp": 40, "attack": 45, "defense": 40, "sp_attack": 35, "sp_defense": 35, "speed": 56},
		"base_exp": 50,
		"catch_rate": 255,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 5, "move": "sand_attack"},
			{"level": 9, "move": "gust"},
			{"level": 15, "move": "quick_attack"},
			{"level": 21, "move": "wing_attack"},
		],
		"evolution": {"to": 17, "method": "level", "level": 18},
	},
	17: {
		"name": "Pidgeotto",
		"types": ["normal", "flying"],
		"base_stats": {"hp": 63, "attack": 60, "defense": 55, "sp_attack": 50, "sp_defense": 50, "speed": 71},
		"base_exp": 122,
		"catch_rate": 120,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 1, "move": "gust"},
			{"level": 15, "move": "quick_attack"},
			{"level": 21, "move": "wing_attack"},
		],
		"evolution": {"to": 18, "method": "level", "level": 36},
	},
	# -- Rattata --
	19: {
		"name": "Rattata",
		"types": ["normal"],
		"base_stats": {"hp": 30, "attack": 56, "defense": 35, "sp_attack": 25, "sp_defense": 35, "speed": 72},
		"base_exp": 51,
		"catch_rate": 255,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 4, "move": "tail_whip"},
			{"level": 7, "move": "quick_attack"},
			{"level": 14, "move": "bite"},
		],
		"evolution": {"to": 20, "method": "level", "level": 20},
	},
	20: {
		"name": "Raticate",
		"types": ["normal"],
		"base_stats": {"hp": 55, "attack": 81, "defense": 60, "sp_attack": 50, "sp_defense": 70, "speed": 97},
		"base_exp": 145,
		"catch_rate": 127,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 1, "move": "quick_attack"},
			{"level": 14, "move": "bite"},
			{"level": 27, "move": "hyper_fang"},
		],
	},
	# -- Caterpie line --
	10: {
		"name": "Caterpie",
		"types": ["bug"],
		"base_stats": {"hp": 45, "attack": 30, "defense": 35, "sp_attack": 20, "sp_defense": 20, "speed": 45},
		"base_exp": 39,
		"catch_rate": 255,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 1, "move": "string_shot"},
		],
		"evolution": {"to": 11, "method": "level", "level": 7},
	},
	11: {
		"name": "Metapod",
		"types": ["bug"],
		"base_stats": {"hp": 50, "attack": 20, "defense": 55, "sp_attack": 25, "sp_defense": 25, "speed": 30},
		"base_exp": 72,
		"catch_rate": 120,
		"learnset": [
			{"level": 1, "move": "harden"},
		],
		"evolution": {"to": 12, "method": "level", "level": 10},
	},
	# -- Geodude --
	74: {
		"name": "Geodude",
		"types": ["rock", "ground"],
		"base_stats": {"hp": 40, "attack": 80, "defense": 100, "sp_attack": 30, "sp_defense": 30, "speed": 20},
		"base_exp": 60,
		"catch_rate": 255,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 6, "move": "defense_curl"},
			{"level": 11, "move": "rock_throw"},
			{"level": 16, "move": "rock_slide"},
		],
	},
	# -- Zubat --
	41: {
		"name": "Zubat",
		"types": ["poison", "flying"],
		"base_stats": {"hp": 40, "attack": 45, "defense": 35, "sp_attack": 30, "sp_defense": 40, "speed": 55},
		"base_exp": 49,
		"catch_rate": 255,
		"learnset": [
			{"level": 1, "move": "leech_life"},
			{"level": 6, "move": "supersonic"},
			{"level": 11, "move": "bite"},
			{"level": 16, "move": "wing_attack"},
		],
	},
	# -- Oddish --
	43: {
		"name": "Oddish",
		"types": ["grass", "poison"],
		"base_stats": {"hp": 45, "attack": 50, "defense": 55, "sp_attack": 75, "sp_defense": 65, "speed": 30},
		"base_exp": 64,
		"catch_rate": 255,
		"learnset": [
			{"level": 1, "move": "absorb"},
			{"level": 7, "move": "poison_powder"},
			{"level": 14, "move": "acid"},
		],
	},
	# -- Mankey --
	56: {
		"name": "Mankey",
		"types": ["fighting"],
		"base_stats": {"hp": 40, "attack": 80, "defense": 35, "sp_attack": 35, "sp_defense": 45, "speed": 70},
		"base_exp": 61,
		"catch_rate": 190,
		"learnset": [
			{"level": 1, "move": "scratch"},
			{"level": 1, "move": "leer"},
			{"level": 9, "move": "low_kick"},
			{"level": 15, "move": "karate_chop"},
		],
	},
	# -- Gastly --
	92: {
		"name": "Gastly",
		"types": ["ghost", "poison"],
		"base_stats": {"hp": 30, "attack": 35, "defense": 30, "sp_attack": 100, "sp_defense": 35, "speed": 80},
		"base_exp": 62,
		"catch_rate": 190,
		"learnset": [
			{"level": 1, "move": "lick"},
			{"level": 1, "move": "hypnosis"},
			{"level": 8, "move": "spite"},
			{"level": 13, "move": "shadow_ball"},
		],
	},
	# -- Onix --
	95: {
		"name": "Onix",
		"types": ["rock", "ground"],
		"base_stats": {"hp": 35, "attack": 45, "defense": 160, "sp_attack": 30, "sp_defense": 45, "speed": 70},
		"base_exp": 77,
		"catch_rate": 45,
		"learnset": [
			{"level": 1, "move": "tackle"},
			{"level": 1, "move": "screech"},
			{"level": 9, "move": "rock_throw"},
			{"level": 15, "move": "rock_slide"},
			{"level": 23, "move": "slam"},
		],
	},
}

static func get_species(id: int) -> Dictionary:
	if id in species_data:
		return species_data[id]
	return {}

static func get_species_name(id: int) -> String:
	var data = get_species(id)
	if data:
		return data["name"]
	return "???"

class_name MoveDatabase
extends RefCounted
## Static database of all Pokemon moves.

static var moves_data: Dictionary = {
	# Normal moves
	"tackle": {"name": "Tackle", "type": "normal", "category": "physical", "power": 40, "accuracy": 100, "pp": 35, "description": "A physical charge attack."},
	"scratch": {"name": "Scratch", "type": "normal", "category": "physical", "power": 40, "accuracy": 100, "pp": 35, "description": "Scratches with sharp claws."},
	"quick_attack": {"name": "Quick Attack", "type": "normal", "category": "physical", "power": 40, "accuracy": 100, "pp": 30, "priority": 1, "description": "An extremely fast attack."},
	"slam": {"name": "Slam", "type": "normal", "category": "physical", "power": 80, "accuracy": 75, "pp": 20, "description": "Slams the foe with a tail etc."},
	"hyper_fang": {"name": "Hyper Fang", "type": "normal", "category": "physical", "power": 80, "accuracy": 90, "pp": 15, "description": "Attacks with sharp fangs."},
	"slash": {"name": "Slash", "type": "normal", "category": "physical", "power": 70, "accuracy": 100, "pp": 20, "description": "Slashes with claws or blades."},
	"bite": {"name": "Bite", "type": "dark", "category": "physical", "power": 60, "accuracy": 100, "pp": 25, "description": "Bites with vicious fangs."},

	# Status moves
	"growl": {"name": "Growl", "type": "normal", "category": "status", "power": 0, "accuracy": 100, "pp": 40, "description": "Reduces the foe's Attack."},
	"tail_whip": {"name": "Tail Whip", "type": "normal", "category": "status", "power": 0, "accuracy": 100, "pp": 30, "description": "Lowers the foe's Defense."},
	"leer": {"name": "Leer", "type": "normal", "category": "status", "power": 0, "accuracy": 100, "pp": 30, "description": "Reduces the foe's Defense."},
	"sand_attack": {"name": "Sand Attack", "type": "ground", "category": "status", "power": 0, "accuracy": 100, "pp": 15, "description": "Reduces accuracy with sand."},
	"harden": {"name": "Harden", "type": "normal", "category": "status", "power": 0, "accuracy": 100, "pp": 30, "description": "Raises Defense."},
	"defense_curl": {"name": "Defense Curl", "type": "normal", "category": "status", "power": 0, "accuracy": 100, "pp": 40, "description": "Curls up to raise Defense."},
	"string_shot": {"name": "String Shot", "type": "bug", "category": "status", "power": 0, "accuracy": 95, "pp": 40, "description": "Reduces the foe's Speed."},
	"screech": {"name": "Screech", "type": "normal", "category": "status", "power": 0, "accuracy": 85, "pp": 40, "description": "Sharply reduces Defense."},
	"supersonic": {"name": "Supersonic", "type": "normal", "category": "status", "power": 0, "accuracy": 55, "pp": 20, "description": "May confuse the foe."},
	"hypnosis": {"name": "Hypnosis", "type": "psychic", "category": "status", "power": 0, "accuracy": 60, "pp": 20, "description": "May put the foe to sleep."},
	"spite": {"name": "Spite", "type": "ghost", "category": "status", "power": 0, "accuracy": 100, "pp": 10, "description": "Reduces PP of foe's last move."},
	"thunder_wave": {"name": "Thunder Wave", "type": "electric", "category": "status", "power": 0, "accuracy": 90, "pp": 20, "description": "May paralyze the foe."},
	"poison_powder": {"name": "Poison Powder", "type": "poison", "category": "status", "power": 0, "accuracy": 75, "pp": 35, "description": "May poison the foe."},
	"leech_seed": {"name": "Leech Seed", "type": "grass", "category": "status", "power": 0, "accuracy": 90, "pp": 10, "description": "Seeds the foe to drain HP."},

	# Electric moves
	"thunder_shock": {"name": "Thunder Shock", "type": "electric", "category": "special", "power": 40, "accuracy": 100, "pp": 30, "description": "An electric shock attack."},
	"thunderbolt": {"name": "Thunderbolt", "type": "electric", "category": "special", "power": 90, "accuracy": 100, "pp": 15, "description": "A strong electric attack."},

	# Fire moves
	"ember": {"name": "Ember", "type": "fire", "category": "special", "power": 40, "accuracy": 100, "pp": 25, "description": "A weak fire attack."},
	"flamethrower": {"name": "Flamethrower", "type": "fire", "category": "special", "power": 90, "accuracy": 100, "pp": 15, "description": "A powerful fire attack."},
	"fire_blast": {"name": "Fire Blast", "type": "fire", "category": "special", "power": 110, "accuracy": 85, "pp": 5, "description": "A fiery blast that may burn."},

	# Water moves
	"water_gun": {"name": "Water Gun", "type": "water", "category": "special", "power": 40, "accuracy": 100, "pp": 25, "description": "Squirts water at the foe."},
	"water_pulse": {"name": "Water Pulse", "type": "water", "category": "special", "power": 60, "accuracy": 100, "pp": 20, "description": "Attacks with ultrasonic waves."},
	"hydro_pump": {"name": "Hydro Pump", "type": "water", "category": "special", "power": 110, "accuracy": 80, "pp": 5, "description": "A powerful water attack."},

	# Grass moves
	"vine_whip": {"name": "Vine Whip", "type": "grass", "category": "physical", "power": 45, "accuracy": 100, "pp": 25, "description": "Strikes with slender vines."},
	"razor_leaf": {"name": "Razor Leaf", "type": "grass", "category": "physical", "power": 55, "accuracy": 95, "pp": 25, "description": "Cuts with leaves."},
	"solar_beam": {"name": "Solar Beam", "type": "grass", "category": "special", "power": 120, "accuracy": 100, "pp": 10, "description": "A 2-turn solar blast."},
	"absorb": {"name": "Absorb", "type": "grass", "category": "special", "power": 20, "accuracy": 100, "pp": 25, "description": "An HP-draining attack."},

	# Flying moves
	"gust": {"name": "Gust", "type": "flying", "category": "special", "power": 40, "accuracy": 100, "pp": 35, "description": "Whips up a strong gust."},
	"wing_attack": {"name": "Wing Attack", "type": "flying", "category": "physical", "power": 60, "accuracy": 100, "pp": 35, "description": "Strikes with wings."},

	# Fighting moves
	"low_kick": {"name": "Low Kick", "type": "fighting", "category": "physical", "power": 50, "accuracy": 100, "pp": 20, "description": "A low sweeping kick."},
	"karate_chop": {"name": "Karate Chop", "type": "fighting", "category": "physical", "power": 50, "accuracy": 100, "pp": 25, "description": "A chopping attack."},
	"double_kick": {"name": "Double Kick", "type": "fighting", "category": "physical", "power": 30, "accuracy": 100, "pp": 30, "description": "Kicks the foe twice."},

	# Poison moves
	"acid": {"name": "Acid", "type": "poison", "category": "special", "power": 40, "accuracy": 100, "pp": 30, "description": "Sprays a hide-melting acid."},

	# Rock moves
	"rock_throw": {"name": "Rock Throw", "type": "rock", "category": "physical", "power": 50, "accuracy": 90, "pp": 15, "description": "Throws small rocks."},
	"rock_slide": {"name": "Rock Slide", "type": "rock", "category": "physical", "power": 75, "accuracy": 90, "pp": 10, "description": "Large boulders are hurled."},

	# Bug moves
	"leech_life": {"name": "Leech Life", "type": "bug", "category": "physical", "power": 80, "accuracy": 100, "pp": 10, "description": "An HP-draining bite."},

	# Ghost moves
	"lick": {"name": "Lick", "type": "ghost", "category": "physical", "power": 30, "accuracy": 100, "pp": 30, "description": "Licks with a long tongue."},
	"shadow_ball": {"name": "Shadow Ball", "type": "ghost", "category": "special", "power": 80, "accuracy": 100, "pp": 15, "description": "Hurls a shadowy blob."},

	# Psychic moves
	"confusion": {"name": "Confusion", "type": "psychic", "category": "special", "power": 50, "accuracy": 100, "pp": 25, "description": "A weak psychic attack."},
}

static func get_move(move_name: String) -> Dictionary:
	if move_name in moves_data:
		return moves_data[move_name].duplicate()
	return {}

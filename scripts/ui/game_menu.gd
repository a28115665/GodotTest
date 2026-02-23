extends CanvasLayer
## In-game pause menu for Pokemon, Bag, Save, etc.

@onready var panel: NinePatchRect = $Panel
@onready var menu_container: VBoxContainer = $Panel/VBoxContainer

var is_open: bool = false
var buttons: Array[Button] = []

signal menu_closed

func _ready() -> void:
	add_to_group("game_menu")
	panel.visible = false
	_create_menu_items()

func _create_menu_items() -> void:
	var items = ["POKEMON", "BAG", "PLAYER", "SAVE", "OPTION", "EXIT"]
	for item in items:
		var btn = Button.new()
		btn.text = item
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(_on_menu_item_pressed.bind(item))
		menu_container.add_child(btn)
		buttons.append(btn)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if is_open:
			close_menu()
		else:
			open_menu()

func open_menu() -> void:
	if is_open:
		return
	is_open = true
	panel.visible = true
	get_tree().paused = true
	if buttons.size() > 0:
		buttons[0].grab_focus()

func close_menu() -> void:
	if not is_open:
		return
	is_open = false
	panel.visible = false
	get_tree().paused = false
	menu_closed.emit()

func _on_menu_item_pressed(item: String) -> void:
	match item:
		"POKEMON":
			_show_pokemon_summary()
		"BAG":
			_show_bag()
		"PLAYER":
			_show_player_info()
		"SAVE":
			_save_game()
		"EXIT":
			close_menu()

func _show_pokemon_summary() -> void:
	# Simple text display for now
	var dialogue = get_tree().get_first_node_in_group("dialogue_box")
	if dialogue and GameData.party.size() > 0:
		close_menu()
		var lines: Array[String] = []
		for pokemon in GameData.party:
			var species = PokemonDatabase.get_species(pokemon.species_id)
			var type_str = "/".join(species.get("types", []))
			lines.append(pokemon.get_display_name() + " Lv" + str(pokemon.level) + " HP:" + str(pokemon.current_hp) + "/" + str(pokemon.max_hp) + " [" + type_str.to_upper() + "]")
		var player = get_tree().get_first_node_in_group("player")
		if player: player.lock_input()
		dialogue.show_dialogue_sequence(lines)
		await dialogue.dialogue_finished
		if player: player.unlock_input()

func _show_bag() -> void:
	var dialogue = get_tree().get_first_node_in_group("dialogue_box")
	if dialogue:
		close_menu()
		var lines: Array[String] = []
		if GameData.inventory.is_empty():
			lines.append("Bag is empty!")
		else:
			for item_name in GameData.inventory:
				lines.append(item_name.to_upper() + " x" + str(GameData.inventory[item_name]))
		var player = get_tree().get_first_node_in_group("player")
		if player: player.lock_input()
		dialogue.show_dialogue_sequence(lines)
		await dialogue.dialogue_finished
		if player: player.unlock_input()

func _show_player_info() -> void:
	var dialogue = get_tree().get_first_node_in_group("dialogue_box")
	if dialogue:
		close_menu()
		var hours = int(GameData.play_time / 3600)
		var minutes = int(fmod(GameData.play_time, 3600) / 60)
		var lines: Array[String] = [
			"Player: " + GameData.player_name,
			"Money: $" + str(GameData.money),
			"Badges: " + str(GameData.badges.count(true)),
			"Pokedex: " + str(GameData.pokedex_caught.size()) + " caught, " + str(GameData.pokedex_seen.size()) + " seen",
			"Time: " + str(hours) + "h " + str(minutes) + "m",
		]
		var player = get_tree().get_first_node_in_group("player")
		if player: player.lock_input()
		dialogue.show_dialogue_sequence(lines)
		await dialogue.dialogue_finished
		if player: player.unlock_input()

func _save_game() -> void:
	var dialogue = get_tree().get_first_node_in_group("dialogue_box")
	if dialogue:
		close_menu()
		GameData.save_game()
		var player = get_tree().get_first_node_in_group("player")
		if player: player.lock_input()
		dialogue.show_dialogue("Game saved!")
		await dialogue.dialogue_finished
		if player: player.unlock_input()

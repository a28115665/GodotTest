extends Node2D
## Main battle scene controller - handles turn-based Pokemon battles.

enum BattleState {
	INTRO,
	PLAYER_TURN,
	ENEMY_TURN,
	EXECUTING,
	PLAYER_FAINTED,
	ENEMY_FAINTED,
	BATTLE_END,
	CATCHING,
	RUNNING,
}

var state: BattleState = BattleState.INTRO
var player_pokemon: PokemonInstance
var enemy_pokemon: PokemonInstance

# UI references
@onready var player_sprite: Sprite2D = $PlayerPokemon/Sprite2D
@onready var enemy_sprite: Sprite2D = $EnemyPokemon/Sprite2D
@onready var player_hp_bar: ProgressBar = $UI/PlayerInfo/HPBar
@onready var player_hp_label: Label = $UI/PlayerInfo/HPLabel
@onready var player_name_label: Label = $UI/PlayerInfo/NameLabel
@onready var player_level_label: Label = $UI/PlayerInfo/LevelLabel
@onready var enemy_hp_bar: ProgressBar = $UI/EnemyInfo/HPBar
@onready var enemy_name_label: Label = $UI/EnemyInfo/NameLabel
@onready var enemy_level_label: Label = $UI/EnemyInfo/LevelLabel
@onready var message_label: RichTextLabel = $UI/MessageBox/Label
@onready var message_box: NinePatchRect = $UI/MessageBox
@onready var action_menu: VBoxContainer = $UI/ActionMenu
@onready var action_menu_bg: ColorRect = $UI/ActionMenuBG
@onready var move_menu: ScrollContainer = $UI/MoveMenu
@onready var move_list: VBoxContainer = $UI/MoveMenu/MoveList
@onready var fight_btn: Button = $UI/ActionMenu/FightBtn
@onready var bag_btn: Button = $UI/ActionMenu/BagBtn
@onready var pokemon_btn: Button = $UI/ActionMenu/PokemonBtn
@onready var run_btn: Button = $UI/ActionMenu/RunBtn

var selected_action: int = 0
var selected_move: int = 0
var message_queue: Array[String] = []
var awaiting_input: bool = false

func _ready() -> void:
	player_pokemon = BattleManager.player_pokemon
	enemy_pokemon = BattleManager.enemy_pokemon

	_setup_sprites()
	_update_ui()
	_hide_menus()

	# Connect buttons
	fight_btn.pressed.connect(_on_fight_pressed)
	bag_btn.pressed.connect(_on_bag_pressed)
	pokemon_btn.pressed.connect(_on_pokemon_pressed)
	run_btn.pressed.connect(_on_run_pressed)

	_start_battle()

func _setup_sprites() -> void:
	player_sprite.texture = SpriteGenerator.create_pokemon_sprite(player_pokemon.species_id, true)
	player_sprite.scale = Vector2(3, 3)
	enemy_sprite.texture = SpriteGenerator.create_pokemon_sprite(enemy_pokemon.species_id, false)
	enemy_sprite.scale = Vector2(3, 3)

func _update_ui() -> void:
	# Player info
	player_name_label.text = player_pokemon.get_display_name()
	player_level_label.text = "Lv" + str(player_pokemon.level)
	player_hp_bar.max_value = player_pokemon.max_hp
	player_hp_bar.value = player_pokemon.current_hp
	player_hp_label.text = str(player_pokemon.current_hp) + "/" + str(player_pokemon.max_hp)

	# HP bar color
	var hp_ratio = float(player_pokemon.current_hp) / float(player_pokemon.max_hp)
	if hp_ratio > 0.5:
		player_hp_bar.modulate = Color.GREEN
	elif hp_ratio > 0.2:
		player_hp_bar.modulate = Color.YELLOW
	else:
		player_hp_bar.modulate = Color.RED

	# Enemy info
	enemy_name_label.text = enemy_pokemon.get_display_name()
	enemy_level_label.text = "Lv" + str(enemy_pokemon.level)
	enemy_hp_bar.max_value = enemy_pokemon.max_hp
	enemy_hp_bar.value = enemy_pokemon.current_hp

	var enemy_hp_ratio = float(enemy_pokemon.current_hp) / float(enemy_pokemon.max_hp)
	if enemy_hp_ratio > 0.5:
		enemy_hp_bar.modulate = Color.GREEN
	elif enemy_hp_ratio > 0.2:
		enemy_hp_bar.modulate = Color.YELLOW
	else:
		enemy_hp_bar.modulate = Color.RED

func _start_battle() -> void:
	state = BattleState.INTRO
	var intro_text = ""
	if BattleManager.is_trainer_battle:
		intro_text = BattleManager.trainer_name + " wants to battle!"
	else:
		intro_text = "Wild " + enemy_pokemon.get_display_name() + " appeared!"

	await _show_message(intro_text)
	await _show_message("Go! " + player_pokemon.get_display_name() + "!")
	_show_action_menu()

func _show_action_menu() -> void:
	state = BattleState.PLAYER_TURN
	action_menu.visible = true
	action_menu_bg.visible = true
	move_menu.visible = false
	fight_btn.grab_focus()

func _hide_menus() -> void:
	action_menu.visible = false
	action_menu_bg.visible = false
	move_menu.visible = false

func _on_fight_pressed() -> void:
	_show_move_menu()

func _on_bag_pressed() -> void:
	if not BattleManager.is_trainer_battle:
		_try_catch()
	else:
		await _show_message("Can't use items in trainer battles!")
		_show_action_menu()

func _on_pokemon_pressed() -> void:
	# Simplified: cycle to next alive pokemon
	var found = false
	for i in range(GameData.party.size()):
		if i != BattleManager.player_party_index and GameData.party[i].current_hp > 0:
			BattleManager.player_party_index = i
			player_pokemon = GameData.party[i]
			BattleManager.player_pokemon = player_pokemon
			_setup_sprites()
			_update_ui()
			await _show_message("Go! " + player_pokemon.get_display_name() + "!")
			found = true
			break
	if not found:
		await _show_message("No other Pokemon available!")
		_show_action_menu()
		return
	# Enemy gets a free turn
	await _execute_enemy_turn()
	if state != BattleState.BATTLE_END:
		_show_action_menu()

func _on_run_pressed() -> void:
	_hide_menus()
	if BattleManager.try_run():
		await _show_message("Got away safely!")
		BattleManager.end_battle("run")
		SceneManager.return_from_battle()
	else:
		await _show_message("Can't escape!")
		await _execute_enemy_turn()
		if state != BattleState.BATTLE_END:
			_show_action_menu()

func _show_move_menu() -> void:
	action_menu.visible = false
	move_menu.visible = true
	move_menu.scroll_vertical = 0

	# Clear old move buttons
	for child in move_list.get_children():
		child.queue_free()

	# Create move buttons
	for i in range(player_pokemon.moves.size()):
		var move = player_pokemon.moves[i]
		var btn = Button.new()
		_apply_button_theme(btn)
		btn.text = move["name"] + " " + str(move["current_pp"]) + "/" + str(move["max_pp"])
		btn.pressed.connect(_on_move_selected.bind(i))
		btn.focus_entered.connect(_scroll_to_button.bind(btn))
		move_list.add_child(btn)
		if i == 0:
			btn.call_deferred("grab_focus")

	# Back button
	var back_btn = Button.new()
	_apply_button_theme(back_btn)
	back_btn.text = "Back"
	back_btn.pressed.connect(_on_move_back)
	back_btn.focus_entered.connect(_scroll_to_button.bind(back_btn))
	move_list.add_child(back_btn)

func _on_move_selected(index: int) -> void:
	if index >= player_pokemon.moves.size():
		return

	var move = player_pokemon.moves[index]
	if move["current_pp"] <= 0:
		await _show_message("No PP left for this move!")
		return

	_hide_menus()
	state = BattleState.EXECUTING

	# Determine turn order by speed
	var player_speed = player_pokemon.get_speed()
	var enemy_speed = enemy_pokemon.get_speed()
	var player_move = move
	var enemy_move = BattleManager.get_enemy_move()

	# Check priority
	var player_priority = player_move.get("priority", 0)
	var enemy_priority = enemy_move.get("priority", 0)

	if player_priority > enemy_priority or (player_priority == enemy_priority and player_speed >= enemy_speed):
		await _execute_player_move(player_move)
		if enemy_pokemon.current_hp > 0:
			await _execute_enemy_move(enemy_move)
	else:
		await _execute_enemy_move(enemy_move)
		if player_pokemon.current_hp > 0:
			await _execute_player_move(player_move)

	# Check battle end conditions
	if enemy_pokemon.is_fainted():
		await _handle_enemy_fainted()
		return
	if player_pokemon.is_fainted():
		await _handle_player_fainted()
		return

	_show_action_menu()

func _on_move_back() -> void:
	_show_action_menu()

func _scroll_to_button(btn: Button) -> void:
	var btn_top = btn.position.y
	var btn_bottom = btn_top + btn.size.y
	var scroll_top = float(move_menu.scroll_vertical)
	var scroll_bottom = scroll_top + move_menu.size.y
	if btn_top < scroll_top:
		move_menu.scroll_vertical = int(btn_top)
	elif btn_bottom > scroll_bottom:
		move_menu.scroll_vertical = int(btn_bottom - move_menu.size.y)

func _apply_button_theme(btn: Button) -> void:
	btn.custom_minimum_size.y = 18
	var normal_sb = StyleBoxFlat.new()
	normal_sb.content_margin_left = 4
	normal_sb.content_margin_top = 0
	normal_sb.content_margin_right = 4
	normal_sb.content_margin_bottom = 0
	normal_sb.bg_color = Color(0.95, 0.95, 0.9, 1)
	var focus_sb = StyleBoxFlat.new()
	focus_sb.content_margin_left = 4
	focus_sb.content_margin_top = 0
	focus_sb.content_margin_right = 4
	focus_sb.content_margin_bottom = 0
	focus_sb.bg_color = Color(0.82, 0.87, 0.82, 1)
	btn.add_theme_stylebox_override("normal", normal_sb)
	btn.add_theme_stylebox_override("hover", focus_sb)
	btn.add_theme_stylebox_override("pressed", focus_sb)
	btn.add_theme_stylebox_override("focus", focus_sb)

func _prompt_replace_move(move_name: String, move_data: Dictionary) -> void:
	var pokemon_name = player_pokemon.get_display_name()
	await _show_message(pokemon_name + " wants to learn " + move_data["name"] + "!")
	await _show_message("But " + pokemon_name + " already knows 4 moves.")
	await _show_message("Delete a move to make room for " + move_data["name"] + "?")

	# Show current moves + Cancel in the MoveMenu area
	move_menu.visible = true
	move_menu.scroll_vertical = 0
	for child in move_list.get_children():
		child.queue_free()

	var selected_index: int = -1

	for i in range(player_pokemon.moves.size()):
		var btn = Button.new()
		_apply_button_theme(btn)
		btn.text = player_pokemon.moves[i]["name"]
		var idx = i
		btn.pressed.connect(func(): selected_index = idx)
		btn.focus_entered.connect(_scroll_to_button.bind(btn))
		move_list.add_child(btn)
		if i == 0:
			btn.call_deferred("grab_focus")

	var cancel_btn = Button.new()
	_apply_button_theme(cancel_btn)
	cancel_btn.text = "Cancel"
	cancel_btn.pressed.connect(func(): selected_index = -2)
	cancel_btn.focus_entered.connect(_scroll_to_button.bind(cancel_btn))
	move_list.add_child(cancel_btn)

	# Wait for player selection
	while selected_index == -1:
		await get_tree().process_frame

	move_menu.visible = false

	if selected_index == -2:
		await _show_message(pokemon_name + " did not learn " + move_data["name"] + ".")
	else:
		var old_move_name = player_pokemon.moves[selected_index]["name"]
		player_pokemon.replace_move(selected_index, move_name)
		await _show_message("1, 2, 3... Poof!")
		await _show_message(pokemon_name + " forgot " + old_move_name + ".")
		await _show_message("And... " + pokemon_name + " learned " + move_data["name"] + "!")

func _execute_player_move(move: Dictionary) -> void:
	move["current_pp"] -= 1
	await _show_message(player_pokemon.get_display_name() + " used " + move["name"] + "!")

	if move["category"] == "status":
		await _show_message("But nothing happened...")
		_update_ui()
		return

	# Check accuracy
	if randi() % 100 >= move["accuracy"]:
		await _show_message("It missed!")
		return

	var damage = BattleManager.calculate_damage(player_pokemon, enemy_pokemon, move)
	enemy_pokemon.take_damage(damage)

	# Animate HP decrease
	await _animate_hp_change(false)

	# Show effectiveness
	var eff = BattleManager.get_effectiveness_text(move["type"], enemy_pokemon.species_id)
	match eff:
		"super_effective":
			await _show_message("It's super effective!")
		"not_effective":
			await _show_message("It's not very effective...")
		"no_effect":
			await _show_message("It had no effect!")

	_update_ui()

func _execute_enemy_move(move: Dictionary) -> void:
	move["current_pp"] -= 1
	await _show_message("Foe " + enemy_pokemon.get_display_name() + " used " + move["name"] + "!")

	if move["category"] == "status":
		await _show_message("But nothing happened...")
		_update_ui()
		return

	if randi() % 100 >= move["accuracy"]:
		await _show_message("It missed!")
		return

	var damage = BattleManager.calculate_damage(enemy_pokemon, player_pokemon, move)
	player_pokemon.take_damage(damage)

	await _animate_hp_change(true)

	var eff = BattleManager.get_effectiveness_text(move["type"], player_pokemon.species_id)
	match eff:
		"super_effective":
			await _show_message("It's super effective!")
		"not_effective":
			await _show_message("It's not very effective...")
		"no_effect":
			await _show_message("It had no effect!")

	_update_ui()

func _execute_enemy_turn() -> void:
	var enemy_move = BattleManager.get_enemy_move()
	await _execute_enemy_move(enemy_move)
	if player_pokemon.is_fainted():
		await _handle_player_fainted()

func _handle_enemy_fainted() -> void:
	state = BattleState.ENEMY_FAINTED
	await _show_message("Foe " + enemy_pokemon.get_display_name() + " fainted!")

	# Award EXP
	var exp_gain = BattleManager.get_exp_yield(enemy_pokemon)
	await _show_message(player_pokemon.get_display_name() + " gained " + str(exp_gain) + " EXP!")

	var result = player_pokemon.add_exp(exp_gain)
	if result["leveled_up"]:
		_update_ui()
		await _show_message(player_pokemon.get_display_name() + " grew to level " + str(result["new_level"]) + "!")
		for new_move in result["new_moves"]:
			var move_data = MoveDatabase.get_move(new_move)
			if move_data:
				if player_pokemon.moves.size() < 4:
					player_pokemon.learn_move(new_move)
					await _show_message(player_pokemon.get_display_name() + " learned " + move_data["name"] + "!")
				else:
					await _prompt_replace_move(new_move, move_data)

	# Check if trainer battle continues
	if BattleManager.is_trainer_battle:
		BattleManager.trainer_party_index += 1
		if BattleManager.trainer_party_index < BattleManager.trainer_party.size():
			enemy_pokemon = BattleManager.trainer_party[BattleManager.trainer_party_index]
			BattleManager.enemy_pokemon = enemy_pokemon
			_setup_sprites()
			_update_ui()
			await _show_message(BattleManager.trainer_name + " sent out " + enemy_pokemon.get_display_name() + "!")
			_show_action_menu()
			return

	# Set trainer defeated flag
	if BattleManager.is_trainer_battle and BattleManager.trainer_defeated_flag != "":
		GameData.set_flag(BattleManager.trainer_defeated_flag)

	state = BattleState.BATTLE_END
	BattleManager.end_battle("win")
	await _show_message("You won!")
	SceneManager.return_from_battle()

func _handle_player_fainted() -> void:
	state = BattleState.PLAYER_FAINTED
	await _show_message(player_pokemon.get_display_name() + " fainted!")

	# Check if any party members alive
	if BattleManager.check_player_party_alive():
		# Switch to next alive pokemon
		for i in range(GameData.party.size()):
			if GameData.party[i].current_hp > 0:
				BattleManager.player_party_index = i
				player_pokemon = GameData.party[i]
				BattleManager.player_pokemon = player_pokemon
				_setup_sprites()
				_update_ui()
				await _show_message("Go! " + player_pokemon.get_display_name() + "!")
				_show_action_menu()
				return
	else:
		state = BattleState.BATTLE_END
		await _show_message("You have no more Pokemon!")
		await _show_message("You blacked out!")
		BattleManager.end_battle("lose")
		# Heal party and return to last pokemon center
		GameData.heal_party()
		SceneManager.return_from_battle()

func _try_catch() -> void:
	_hide_menus()
	if not GameData.has_item("pokeball"):
		await _show_message("No Poke Balls left!")
		_show_action_menu()
		return

	GameData.remove_item("pokeball")
	await _show_message("You threw a Poke Ball!")

	# Wiggle animation (simplified)
	for i in range(3):
		await _show_message("...")
		await get_tree().create_timer(0.3).timeout

	if BattleManager.try_catch(enemy_pokemon):
		await _show_message("Gotcha! " + enemy_pokemon.get_display_name() + " was caught!")
		GameData.add_pokemon_to_party(enemy_pokemon)
		state = BattleState.BATTLE_END
		BattleManager.end_battle("caught")
		SceneManager.return_from_battle()
	else:
		await _show_message("Oh no! The Pokemon broke free!")
		await _execute_enemy_turn()
		if state != BattleState.BATTLE_END:
			_show_action_menu()

func _animate_hp_change(is_player: bool) -> void:
	var bar = player_hp_bar if is_player else enemy_hp_bar
	var pokemon = player_pokemon if is_player else enemy_pokemon
	var tween = create_tween()
	tween.tween_property(bar, "value", pokemon.current_hp, 0.5)
	await tween.finished
	_update_ui()

func _show_message(text: String) -> void:
	message_label.text = text
	message_label.visible_characters = 0
	awaiting_input = false

	# Typewriter effect
	for i in range(text.length() + 1):
		message_label.visible_characters = i
		await get_tree().create_timer(0.02).timeout

	# Wait for player input
	awaiting_input = true
	await _wait_for_input()
	awaiting_input = false

func _wait_for_input() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			break

func _process(_delta: float) -> void:
	pass

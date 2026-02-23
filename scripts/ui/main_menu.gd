extends Control
## Main menu screen - New Game, Continue, Options.

@onready var title_label: Label = $VBoxContainer/Title
@onready var new_game_btn: Button = $VBoxContainer/Buttons/NewGameBtn
@onready var continue_btn: Button = $VBoxContainer/Buttons/ContinueBtn
@onready var version_label: Label = $VBoxContainer/Version

var pikachu_sprite: Sprite2D

func _ready() -> void:
	# Setup Pikachu mascot
	pikachu_sprite = Sprite2D.new()
	pikachu_sprite.texture = SpriteGenerator.create_pokemon_sprite(25, false)
	pikachu_sprite.scale = Vector2(4, 4)
	pikachu_sprite.position = Vector2(160, 100)
	add_child(pikachu_sprite)

	# Animate pikachu
	var tween = create_tween().set_loops()
	tween.tween_property(pikachu_sprite, "position:y", 90.0, 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(pikachu_sprite, "position:y", 100.0, 1.0).set_trans(Tween.TRANS_SINE)

	# Check for save file
	continue_btn.disabled = not GameData.has_save()

	new_game_btn.pressed.connect(_on_new_game)
	continue_btn.pressed.connect(_on_continue)

	new_game_btn.grab_focus()

func _on_new_game() -> void:
	# Give player a starter Pikachu (like Yellow version!)
	var pikachu = PokemonInstance.create(25, 5, "")
	GameData.party.clear()
	GameData.add_pokemon_to_party(pikachu)
	GameData.set_flag("got_starter", true)
	GameData.current_map = "pallet_town"
	GameData.player_position = Vector2(5, 8)
	SceneManager.transition_to_scene("res://scenes/maps/pallet_town.tscn")

func _on_continue() -> void:
	if GameData.load_game():
		SceneManager.transition_to_scene("res://scenes/maps/" + GameData.current_map + ".tscn")

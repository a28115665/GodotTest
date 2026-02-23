extends CanvasLayer
## Manages scene transitions with fade effects.

@onready var color_rect: ColorRect = ColorRect.new()
var is_transitioning: bool = false

func _ready() -> void:
	layer = 100
	color_rect.color = Color.BLACK
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.modulate.a = 0.0
	add_child(color_rect)

func transition_to_scene(scene_path: String, transition_type: String = "fade") -> void:
	if is_transitioning:
		return
	is_transitioning = true

	if transition_type == "fade":
		await _fade_out()
		get_tree().change_scene_to_file(scene_path)
		await get_tree().process_frame
		await _fade_in()
	elif transition_type == "battle":
		await _battle_transition()
		get_tree().change_scene_to_file(scene_path)
		await get_tree().process_frame
		await _fade_in()

	is_transitioning = false

func transition_to_battle(wild_pokemon) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	BattleManager.start_wild_battle(wild_pokemon)
	await _battle_transition()
	get_tree().change_scene_to_file("res://scenes/battle/battle_scene.tscn")
	await get_tree().process_frame
	await _fade_in()
	is_transitioning = false

func return_from_battle() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	await _fade_out()
	get_tree().change_scene_to_file("res://scenes/maps/" + GameData.current_map + ".tscn")
	await get_tree().process_frame
	await _fade_in()
	is_transitioning = false

func _fade_out(duration: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	await tween.finished

func _fade_in(duration: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	await tween.finished

func _battle_transition(duration: float = 0.8) -> void:
	# Flash white then black for battle feel
	color_rect.color = Color.WHITE
	for i in range(4):
		var tween = create_tween()
		tween.tween_property(color_rect, "modulate:a", 1.0, 0.08)
		await tween.finished
		tween = create_tween()
		tween.tween_property(color_rect, "modulate:a", 0.0, 0.08)
		await tween.finished
	color_rect.color = Color.BLACK
	var final_tween = create_tween()
	final_tween.tween_property(color_rect, "modulate:a", 1.0, 0.3)
	await final_tween.finished

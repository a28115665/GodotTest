extends CanvasLayer
## RPG-style dialogue box with typewriter effect.

@onready var panel: NinePatchRect = $Panel
@onready var label: RichTextLabel = $Panel/Label
@onready var arrow: Label = $Panel/Arrow

var dialogue_queue: Array[String] = []
var current_text: String = ""
var displayed_chars: int = 0
var is_showing: bool = false
var is_typing: bool = false
var type_speed: float = 0.03
var type_timer: float = 0.0

signal dialogue_finished

func _ready() -> void:
	add_to_group("dialogue_box")
	panel.visible = false
	arrow.visible = false

func _process(delta: float) -> void:
	if not is_showing:
		return

	if is_typing:
		type_timer += delta
		if type_timer >= type_speed:
			type_timer = 0.0
			displayed_chars += 1
			label.visible_characters = displayed_chars
			if displayed_chars >= current_text.length():
				is_typing = false
				arrow.visible = true

	if Input.is_action_just_pressed("ui_accept"):
		if is_typing:
			# Skip typing, show all text
			displayed_chars = current_text.length()
			label.visible_characters = displayed_chars
			is_typing = false
			arrow.visible = true
		else:
			_advance_dialogue()

func show_dialogue(text: String) -> void:
	dialogue_queue = [text]
	_start_dialogue()

func show_dialogue_sequence(texts: Array) -> void:
	dialogue_queue.clear()
	for t in texts:
		dialogue_queue.append(str(t))
	_start_dialogue()

func _start_dialogue() -> void:
	if dialogue_queue.is_empty():
		return
	is_showing = true
	panel.visible = true
	_show_next_text()

func _show_next_text() -> void:
	if dialogue_queue.is_empty():
		_close_dialogue()
		return

	current_text = dialogue_queue.pop_front()
	label.text = current_text
	displayed_chars = 0
	label.visible_characters = 0
	is_typing = true
	arrow.visible = false
	type_timer = 0.0

func _advance_dialogue() -> void:
	if dialogue_queue.is_empty():
		_close_dialogue()
	else:
		_show_next_text()

func _close_dialogue() -> void:
	is_showing = false
	panel.visible = false
	arrow.visible = false
	dialogue_finished.emit()

extends CharacterBody2D
## NPC character that can be interacted with for dialogue.

@export var npc_name: String = "NPC"
@export var npc_type: String = "trainer"  # professor, rival, nurse, trainer
@export var dialogue_lines: Array[String] = ["Hello there!"]
@export var facing_direction: String = "down"
@export var look_at_player: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var current_dialogue_index: int = 0

func _ready() -> void:
	add_to_group("npcs")
	sprite.texture = SpriteGenerator.create_npc_sprite(npc_type)

func interact() -> void:
	if look_at_player:
		_face_player()

	var dialogue_box = get_tree().get_first_node_in_group("dialogue_box")
	if dialogue_box:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.lock_input()

		dialogue_box.show_dialogue_sequence(dialogue_lines)
		await dialogue_box.dialogue_finished

		if player:
			player.unlock_input()

func _face_player() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	var dir = (player.position - position).normalized()
	if abs(dir.x) > abs(dir.y):
		facing_direction = "right" if dir.x > 0 else "left"
	else:
		facing_direction = "down" if dir.y > 0 else "up"

func set_dialogue(lines: Array[String]) -> void:
	dialogue_lines = lines

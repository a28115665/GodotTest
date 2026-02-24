extends CharacterBody2D
## Player character controller - grid-based movement like Pokemon Yellow.

const TILE_SIZE = 16
const MOVE_SPEED = 4.0  # Tiles per second

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var animation_timer: Timer = $AnimationTimer
@onready var interaction_area: Area2D = $InteractionArea

var is_moving: bool = false
var direction: Vector2 = Vector2.DOWN
var target_position: Vector2 = Vector2.ZERO
var move_progress: float = 0.0
var start_position: Vector2 = Vector2.ZERO
var anim_frame: int = 0
var input_locked: bool = false

# Grass encounter
var steps_in_grass: int = 0
var is_in_tall_grass: bool = false

# Sprite textures
var sprites: Dictionary = {}

signal player_interacted
signal entered_door(door_data: Dictionary)

func _ready() -> void:
	_generate_sprites()
	target_position = position
	_update_sprite()
	animation_timer.timeout.connect(_on_animation_timer)
	animation_timer.start(0.2)

	# Restore position from save (centered on tile)
	if GameData.player_position != Vector2.ZERO:
		position = GameData.player_position * TILE_SIZE + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
		target_position = position

func _generate_sprites() -> void:
	for dir in ["down", "up", "left", "right"]:
		sprites[dir] = []
		for frame in range(3):
			sprites[dir].append(SpriteGenerator.create_player_sprite(dir, frame))

func _physics_process(delta: float) -> void:
	if input_locked:
		return

	if is_moving:
		_process_movement(delta)
	else:
		_process_input()

func _process_input() -> void:
	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		input_dir = Vector2.UP
		direction = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		input_dir = Vector2.DOWN
		direction = Vector2.DOWN
	elif Input.is_action_pressed("move_left"):
		input_dir = Vector2.LEFT
		direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		input_dir = Vector2.RIGHT
		direction = Vector2.RIGHT

	_update_sprite()

	if input_dir != Vector2.ZERO:
		_try_move(input_dir)

	if Input.is_action_just_pressed("ui_accept"):
		_interact()

func _try_move(dir: Vector2) -> void:
	# Check collision with raycast
	ray_cast.target_position = dir * TILE_SIZE
	ray_cast.force_raycast_update()

	if ray_cast.is_colliding():
		return

	start_position = position
	target_position = position + dir * TILE_SIZE
	is_moving = true
	move_progress = 0.0

func _process_movement(delta: float) -> void:
	move_progress += MOVE_SPEED * delta

	if move_progress >= 1.0:
		position = target_position
		is_moving = false
		move_progress = 0.0
		_on_step_completed()
	else:
		position = start_position.lerp(target_position, move_progress)

func _on_step_completed() -> void:
	# Store integer tile coordinates (player is centered on tile)
	GameData.player_position = Vector2(int(position.x / TILE_SIZE), int(position.y / TILE_SIZE))

	# Check for tall grass encounters
	if is_in_tall_grass:
		steps_in_grass += 1
		if steps_in_grass > 2 and randf() < 0.50:
			steps_in_grass = 0
			_trigger_wild_encounter()
	else:
		steps_in_grass = 0

	# Check for door/warp tiles
	_check_warps()

func _trigger_wild_encounter() -> void:
	# Need at least one Pokemon in party to battle
	if GameData.party.is_empty():
		return
	input_locked = true
	var encounter_table = _get_encounter_table()
	if encounter_table.is_empty():
		input_locked = false
		return

	var encounter = encounter_table[randi() % encounter_table.size()]
	var wild_pokemon = PokemonInstance.create(encounter["id"], encounter["level"])
	SceneManager.transition_to_battle(wild_pokemon)

func _get_encounter_table() -> Array:
	# Return encounter table based on current map
	var map = get_parent()
	if map.has_method("get_encounter_table"):
		return map.get_encounter_table()
	return []

func _check_warps() -> void:
	var map = get_parent()
	if map.has_method("get_warps"):
		var warps = map.get_warps()
		var tile_pos = Vector2(int(position.x / TILE_SIZE), int(position.y / TILE_SIZE))
		for warp in warps:
			if warp["position"] == tile_pos:
				entered_door.emit(warp)
				return

func _interact() -> void:
	# Check for NPC in front of player
	var check_pos = position + direction * TILE_SIZE
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = check_pos
	query.collision_mask = 4  # NPC layer
	var results = space_state.intersect_point(query)

	if results.size() > 0:
		var collider = results[0]["collider"]
		if collider.has_method("interact"):
			collider.interact()
			return

	# Check for signs or other interactables
	var map = get_parent()
	if map.has_method("get_sign_text"):
		var tile_pos = Vector2(int(check_pos.x / TILE_SIZE), int(check_pos.y / TILE_SIZE))
		var text = map.get_sign_text(tile_pos)
		if text != "":
			player_interacted.emit()
			var dialogue_box = get_tree().get_first_node_in_group("dialogue_box")
			if dialogue_box:
				dialogue_box.show_dialogue(text)

func _update_sprite() -> void:
	var dir_name = _direction_to_string()
	if dir_name in sprites and sprites[dir_name].size() > 0:
		var frame = 0
		if is_moving:
			frame = anim_frame % 3
		sprite.texture = sprites[dir_name][frame]

func _direction_to_string() -> String:
	if direction == Vector2.UP: return "up"
	if direction == Vector2.DOWN: return "down"
	if direction == Vector2.LEFT: return "left"
	return "right"

func _on_animation_timer() -> void:
	if is_moving:
		anim_frame += 1
		_update_sprite()

func set_in_tall_grass(value: bool) -> void:
	is_in_tall_grass = value

func lock_input() -> void:
	input_locked = true

func unlock_input() -> void:
	input_locked = false

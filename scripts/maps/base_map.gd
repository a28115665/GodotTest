extends Node2D
## Base class for all game maps.
## Override get_encounter_table(), get_warps(), get_sign_text() in child maps.

const TILE_SIZE = 16

@onready var player_scene = preload("res://scenes/player.tscn")
@onready var camera: Camera2D = $Camera2D

var map_data: Array = []  # 2D array of tile types
var map_width: int = 20
var map_height: int = 18
var collision_tiles: Array = ["wall", "tree", "water", "fence"]
var tall_grass_tiles: Array = ["tall_grass"]

# Tiles drawn via sprites
var tile_sprites: Array = []
var collision_bodies: Array = []

func _ready() -> void:
	_build_map()
	_spawn_player()
	_spawn_npcs()

func _build_map() -> void:
	_define_map()

	for y in range(map_height):
		for x in range(map_width):
			if y >= map_data.size() or x >= map_data[y].size():
				continue
			var tile_type = map_data[y][x]
			var tile_sprite = Sprite2D.new()
			tile_sprite.texture = SpriteGenerator.create_tile(tile_type)
			tile_sprite.position = Vector2(x * TILE_SIZE + TILE_SIZE / 2, y * TILE_SIZE + TILE_SIZE / 2)
			tile_sprite.z_index = -1
			add_child(tile_sprite)
			tile_sprites.append(tile_sprite)

			# Add collision for blocking tiles
			if tile_type in collision_tiles:
				var body = StaticBody2D.new()
				body.position = Vector2(x * TILE_SIZE + TILE_SIZE / 2, y * TILE_SIZE + TILE_SIZE / 2)
				var collision = CollisionShape2D.new()
				var shape = RectangleShape2D.new()
				shape.size = Vector2(TILE_SIZE, TILE_SIZE)
				collision.shape = shape
				body.add_child(collision)
				body.collision_layer = 1  # Walls layer
				body.collision_mask = 0
				add_child(body)
				collision_bodies.append(body)

			# Add tall grass detection areas
			if tile_type in tall_grass_tiles:
				var area = Area2D.new()
				area.position = Vector2(x * TILE_SIZE + TILE_SIZE / 2, y * TILE_SIZE + TILE_SIZE / 2)
				var area_col = CollisionShape2D.new()
				var area_shape = RectangleShape2D.new()
				area_shape.size = Vector2(TILE_SIZE - 2, TILE_SIZE - 2)
				area_col.shape = area_shape
				area.add_child(area_col)
				area.collision_layer = 8  # Encounters layer
				area.collision_mask = 2   # Player layer
				area.body_entered.connect(_on_grass_entered)
				area.body_exited.connect(_on_grass_exited)
				add_child(area)

func _spawn_player() -> void:
	var player = player_scene.instantiate()
	player.position = GameData.player_position * TILE_SIZE + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
	player.add_to_group("player")
	add_child(player)

	# Setup camera to follow player
	camera.position = player.position
	player.entered_door.connect(_on_player_entered_door)

	# Make camera follow player
	camera.reparent(player)
	camera.position = Vector2.ZERO

func _spawn_npcs() -> void:
	# Override in child classes
	pass

func _define_map() -> void:
	# Override in child classes
	map_data = []
	for y in range(map_height):
		var row = []
		for x in range(map_width):
			row.append("grass")
		map_data.append(row)

func get_tile_type(tile_pos: Vector2) -> String:
	var x = int(tile_pos.x)
	var y = int(tile_pos.y)
	if y >= 0 and y < map_data.size() and x >= 0 and x < map_data[y].size():
		return map_data[y][x]
	return ""

func get_encounter_table() -> Array:
	return []

func get_warps() -> Array:
	return []

func get_sign_text(tile_pos: Vector2) -> String:
	return ""

func _on_grass_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.set_in_tall_grass(true)

func _on_grass_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.set_in_tall_grass(false)

func _on_player_entered_door(warp_data: Dictionary) -> void:
	GameData.current_map = warp_data["target_map"]
	GameData.player_position = warp_data["target_position"]
	SceneManager.transition_to_scene("res://scenes/maps/" + warp_data["target_map"] + ".tscn")

func create_npc(npc_name: String, npc_type: String, pos: Vector2, dialogue: Array[String]) -> Node:
	var npc_scene = preload("res://scenes/npc.tscn")
	var npc = npc_scene.instantiate()
	npc.npc_name = npc_name
	npc.npc_type = npc_type
	npc.position = pos * TILE_SIZE + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
	npc.dialogue_lines = dialogue
	add_child(npc)
	return npc

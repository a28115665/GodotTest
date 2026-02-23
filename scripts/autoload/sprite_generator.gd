class_name SpriteGenerator
extends RefCounted
## Generates pixel art sprites programmatically for all game characters and pokemon.

# Color palettes
const SKIN = Color(1.0, 0.85, 0.7)
const HAIR_BLACK = Color(0.15, 0.15, 0.2)
const RED_HAT = Color(0.9, 0.15, 0.15)
const RED_SHIRT = Color(0.9, 0.2, 0.2)
const BLUE_PANTS = Color(0.2, 0.3, 0.8)
const SHOES = Color(0.3, 0.2, 0.15)
const WHITE = Color.WHITE
const BLACK = Color(0.1, 0.1, 0.1)
const YELLOW = Color(1.0, 0.85, 0.0)
const BROWN = Color(0.55, 0.35, 0.15)
const GREEN = Color(0.2, 0.7, 0.3)
const DARK_GREEN = Color(0.1, 0.5, 0.2)
const BLUE = Color(0.3, 0.5, 0.9)
const ORANGE = Color(0.95, 0.5, 0.1)
const LIGHT_BLUE = Color(0.5, 0.7, 1.0)
const PURPLE = Color(0.6, 0.3, 0.8)
const GRAY = Color(0.6, 0.6, 0.65)
const DARK_GRAY = Color(0.35, 0.35, 0.4)
const PINK = Color(1.0, 0.6, 0.7)
const T = Color(0, 0, 0, 0)  # Transparent

# Bounds-safe pixel setter to prevent Wasm crashes
static func _sp(img: Image, x, y, color: Color) -> void:
	var px := int(x)
	var py := int(y)
	if px >= 0 and px < img.get_width() and py >= 0 and py < img.get_height():
		img.set_pixel(px, py, color)

static func create_player_sprite(direction: String, frame: int = 0) -> ImageTexture:
	var img = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	img.fill(T)

	match direction:
		"down":
			_draw_player_down(img, frame)
		"up":
			_draw_player_up(img, frame)
		"left":
			_draw_player_left(img, frame)
		"right":
			_draw_player_right(img, frame)

	return ImageTexture.create_from_image(img)

static func _draw_player_down(img: Image, frame: int) -> void:
	# Hat
	for x in range(5, 11): _sp(img,x, 0, RED_HAT)
	for x in range(4, 12): _sp(img,x, 1, RED_HAT)
	# Face
	for x in range(5, 11): _sp(img,x, 2, SKIN)
	for x in range(5, 11): _sp(img,x, 3, SKIN)
	_sp(img,6, 3, BLACK)  # Left eye
	_sp(img,9, 3, BLACK)  # Right eye
	for x in range(6, 10): _sp(img,x, 4, SKIN)
	# Body
	for x in range(5, 11): _sp(img,x, 5, RED_SHIRT)
	for x in range(5, 11): _sp(img,x, 6, RED_SHIRT)
	for x in range(4, 12): _sp(img,x, 7, RED_SHIRT)
	for x in range(5, 11): _sp(img,x, 8, RED_SHIRT)
	# Pants
	for x in range(5, 11): _sp(img,x, 9, BLUE_PANTS)
	for x in range(5, 11): _sp(img,x, 10, BLUE_PANTS)
	# Legs/feet
	var offset = 0 if frame == 0 else (1 if frame == 1 else -1)
	for x in range(5, 8): _sp(img,x + (offset if frame != 0 else 0), 11, SHOES)
	for x in range(8, 11): _sp(img,x + (-offset if frame != 0 else 0), 11, SHOES)

static func _draw_player_up(img: Image, frame: int) -> void:
	# Hat
	for x in range(5, 11): _sp(img,x, 0, RED_HAT)
	for x in range(4, 12): _sp(img,x, 1, RED_HAT)
	# Hair/back of head
	for x in range(5, 11): _sp(img,x, 2, HAIR_BLACK)
	for x in range(5, 11): _sp(img,x, 3, HAIR_BLACK)
	for x in range(6, 10): _sp(img,x, 4, HAIR_BLACK)
	# Body
	for x in range(5, 11): _sp(img,x, 5, RED_SHIRT)
	for x in range(5, 11): _sp(img,x, 6, RED_SHIRT)
	for x in range(4, 12): _sp(img,x, 7, RED_SHIRT)
	for x in range(5, 11): _sp(img,x, 8, RED_SHIRT)
	# Pants
	for x in range(5, 11): _sp(img,x, 9, BLUE_PANTS)
	for x in range(5, 11): _sp(img,x, 10, BLUE_PANTS)
	# Legs
	var offset = 0 if frame == 0 else (1 if frame == 1 else -1)
	for x in range(5, 8): _sp(img,x + (offset if frame != 0 else 0), 11, SHOES)
	for x in range(8, 11): _sp(img,x + (-offset if frame != 0 else 0), 11, SHOES)

static func _draw_player_left(img: Image, frame: int) -> void:
	# Hat
	for x in range(4, 10): _sp(img,x, 0, RED_HAT)
	for x in range(3, 10): _sp(img,x, 1, RED_HAT)
	# Face (side view)
	for x in range(5, 10): _sp(img,x, 2, SKIN)
	for x in range(5, 10): _sp(img,x, 3, SKIN)
	_sp(img,5, 3, BLACK)  # Eye
	for x in range(5, 9): _sp(img,x, 4, SKIN)
	# Body
	for x in range(5, 10): _sp(img,x, 5, RED_SHIRT)
	for x in range(5, 11): _sp(img,x, 6, RED_SHIRT)
	for x in range(4, 10): _sp(img,x, 7, RED_SHIRT)
	for x in range(5, 10): _sp(img,x, 8, RED_SHIRT)
	# Pants
	for x in range(5, 10): _sp(img,x, 9, BLUE_PANTS)
	for x in range(5, 10): _sp(img,x, 10, BLUE_PANTS)
	# Feet
	for x in range(5, 9): _sp(img,x, 11, SHOES)

static func _draw_player_right(img: Image, frame: int) -> void:
	# Hat
	for x in range(6, 12): _sp(img,x, 0, RED_HAT)
	for x in range(6, 13): _sp(img,x, 1, RED_HAT)
	# Face
	for x in range(6, 11): _sp(img,x, 2, SKIN)
	for x in range(6, 11): _sp(img,x, 3, SKIN)
	_sp(img,10, 3, BLACK)  # Eye
	for x in range(7, 11): _sp(img,x, 4, SKIN)
	# Body
	for x in range(6, 11): _sp(img,x, 5, RED_SHIRT)
	for x in range(5, 11): _sp(img,x, 6, RED_SHIRT)
	for x in range(6, 12): _sp(img,x, 7, RED_SHIRT)
	for x in range(6, 11): _sp(img,x, 8, RED_SHIRT)
	# Pants
	for x in range(6, 11): _sp(img,x, 9, BLUE_PANTS)
	for x in range(6, 11): _sp(img,x, 10, BLUE_PANTS)
	# Feet
	for x in range(7, 11): _sp(img,x, 11, SHOES)

static func create_npc_sprite(npc_type: String) -> ImageTexture:
	var img = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	img.fill(T)

	match npc_type:
		"professor":
			_draw_professor(img)
		"rival":
			_draw_rival(img)
		"nurse":
			_draw_nurse(img)
		"trainer":
			_draw_trainer(img)
		_:
			_draw_generic_npc(img)

	return ImageTexture.create_from_image(img)

static func _draw_professor(img: Image) -> void:
	# White hair
	for x in range(5, 11): _sp(img,x, 0, GRAY)
	for x in range(4, 12): _sp(img,x, 1, GRAY)
	# Face
	for x in range(5, 11): _sp(img,x, 2, SKIN)
	for x in range(5, 11): _sp(img,x, 3, SKIN)
	_sp(img,6, 3, BLACK)
	_sp(img,9, 3, BLACK)
	for x in range(6, 10): _sp(img,x, 4, SKIN)
	# Lab coat (white)
	for x in range(4, 12): _sp(img,x, 5, WHITE)
	for x in range(4, 12): _sp(img,x, 6, WHITE)
	for x in range(3, 13): _sp(img,x, 7, WHITE)
	for x in range(4, 12): _sp(img,x, 8, WHITE)
	for x in range(4, 12): _sp(img,x, 9, WHITE)
	for x in range(5, 11): _sp(img,x, 10, BROWN)
	for x in range(5, 11): _sp(img,x, 11, SHOES)

static func _draw_rival(img: Image) -> void:
	# Spiky brown hair
	for x in range(5, 11): _sp(img,x, 0, BROWN)
	_sp(img,5, 0, BROWN); _sp(img,7, 0, BROWN); _sp(img,10, 0, BROWN)
	for x in range(4, 12): _sp(img,x, 1, BROWN)
	# Face
	for x in range(5, 11): _sp(img,x, 2, SKIN)
	for x in range(5, 11): _sp(img,x, 3, SKIN)
	_sp(img,6, 3, BLACK)
	_sp(img,9, 3, BLACK)
	for x in range(6, 10): _sp(img,x, 4, SKIN)
	# Purple shirt
	for x in range(5, 11): _sp(img,x, 5, PURPLE)
	for x in range(5, 11): _sp(img,x, 6, PURPLE)
	for x in range(4, 12): _sp(img,x, 7, PURPLE)
	for x in range(5, 11): _sp(img,x, 8, PURPLE)
	# Dark pants
	for x in range(5, 11): _sp(img,x, 9, DARK_GRAY)
	for x in range(5, 11): _sp(img,x, 10, DARK_GRAY)
	for x in range(5, 11): _sp(img,x, 11, SHOES)

static func _draw_nurse(img: Image) -> void:
	# Nurse hat
	for x in range(5, 11): _sp(img,x, 0, WHITE)
	_sp(img,7, 0, Color(1, 0.2, 0.2)); _sp(img,8, 0, Color(1, 0.2, 0.2))
	for x in range(4, 12): _sp(img,x, 1, PINK)
	# Face
	for x in range(5, 11): _sp(img,x, 2, SKIN)
	for x in range(5, 11): _sp(img,x, 3, SKIN)
	_sp(img,6, 3, BLACK)
	_sp(img,9, 3, BLACK)
	for x in range(6, 10): _sp(img,x, 4, SKIN)
	# Nurse outfit
	for x in range(5, 11): _sp(img,x, 5, PINK)
	for x in range(5, 11): _sp(img,x, 6, PINK)
	for x in range(4, 12): _sp(img,x, 7, PINK)
	for x in range(5, 11): _sp(img,x, 8, PINK)
	for x in range(5, 11): _sp(img,x, 9, PINK)
	for x in range(5, 11): _sp(img,x, 10, WHITE)
	for x in range(5, 11): _sp(img,x, 11, WHITE)

static func _draw_trainer(img: Image) -> void:
	# Cap
	for x in range(5, 11): _sp(img,x, 0, BLUE)
	for x in range(4, 12): _sp(img,x, 1, BLUE)
	# Face
	for x in range(5, 11): _sp(img,x, 2, SKIN)
	for x in range(5, 11): _sp(img,x, 3, SKIN)
	_sp(img,6, 3, BLACK); _sp(img,9, 3, BLACK)
	for x in range(6, 10): _sp(img,x, 4, SKIN)
	# Shirt
	for x in range(5, 11): _sp(img,x, 5, GREEN)
	for x in range(5, 11): _sp(img,x, 6, GREEN)
	for x in range(4, 12): _sp(img,x, 7, GREEN)
	for x in range(5, 11): _sp(img,x, 8, GREEN)
	for x in range(5, 11): _sp(img,x, 9, BROWN)
	for x in range(5, 11): _sp(img,x, 10, BROWN)
	for x in range(5, 11): _sp(img,x, 11, SHOES)

static func _draw_generic_npc(img: Image) -> void:
	_draw_trainer(img)

# Pokemon battle sprites (32x32)
static func create_pokemon_sprite(species_id: int, is_back: bool = false) -> ImageTexture:
	var img = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	img.fill(T)

	match species_id:
		25: _draw_pikachu(img, is_back)
		1: _draw_bulbasaur(img, is_back)
		2: _draw_ivysaur(img, is_back)
		4: _draw_charmander(img, is_back)
		5: _draw_charmeleon(img, is_back)
		7: _draw_squirtle(img, is_back)
		8: _draw_wartortle(img, is_back)
		16: _draw_pidgey(img, is_back)
		19: _draw_rattata(img, is_back)
		10: _draw_caterpie(img, is_back)
		74: _draw_geodude(img, is_back)
		41: _draw_zubat(img, is_back)
		43: _draw_oddish(img, is_back)
		56: _draw_mankey(img, is_back)
		92: _draw_gastly(img, is_back)
		95: _draw_onix(img, is_back)
		_: _draw_generic_pokemon(img, is_back)

	return ImageTexture.create_from_image(img)

static func _draw_pikachu(img: Image, is_back: bool) -> void:
	var y_off = 4
	# Body - yellow mouse
	for y in range(y_off + 4, y_off + 16):
		for x in range(8, 24):
			if (x - 16) * (x - 16) + (y - (y_off + 10)) * (y - (y_off + 10)) < 64:
				_sp(img,x, y, YELLOW)
	# Ears
	for i in range(6):
		_sp(img,10 - i/2, y_off + 3 - i, YELLOW)
		_sp(img,11 - i/2, y_off + 3 - i, YELLOW)
		_sp(img,20 + i/2, y_off + 3 - i, YELLOW)
		_sp(img,21 + i/2, y_off + 3 - i, YELLOW)
	# Ear tips (black)
	for i in range(3):
		_sp(img,7 - i/2, y_off - 2 - i, BLACK)
		_sp(img,23 + i/2, y_off - 2 - i, BLACK)
	if not is_back:
		# Eyes
		_sp(img,12, y_off + 7, BLACK)
		_sp(img,13, y_off + 7, BLACK)
		_sp(img,19, y_off + 7, BLACK)
		_sp(img,20, y_off + 7, BLACK)
		# Red cheeks
		_sp(img,9, y_off + 9, Color(1, 0.3, 0.3))
		_sp(img,10, y_off + 9, Color(1, 0.3, 0.3))
		_sp(img,22, y_off + 9, Color(1, 0.3, 0.3))
		_sp(img,23, y_off + 9, Color(1, 0.3, 0.3))
		# Mouth
		_sp(img,15, y_off + 10, BLACK)
		_sp(img,16, y_off + 10, BLACK)
	# Tail (lightning bolt shape)
	var tx = 22 if not is_back else 8
	for i in range(8):
		_sp(img,tx + i/2, y_off + 6 - i, YELLOW)
		_sp(img,tx + 1 + i/2, y_off + 6 - i, YELLOW)
	# Feet
	for x in range(10, 14): _sp(img,x, y_off + 15, YELLOW)
	for x in range(18, 22): _sp(img,x, y_off + 15, YELLOW)

static func _draw_bulbasaur(img: Image, is_back: bool) -> void:
	var y_off = 6
	# Body - blue-green
	var body_color = Color(0.4, 0.75, 0.65)
	for y in range(y_off + 4, y_off + 14):
		for x in range(6, 26):
			if (x - 16) * (x - 16) + (y - (y_off + 10)) * (y - (y_off + 10)) < 80:
				_sp(img,x, y, body_color)
	# Bulb on back
	for y in range(y_off, y_off + 6):
		for x in range(12, 22):
			if (x - 17) * (x - 17) + (y - (y_off + 3)) * (y - (y_off + 3)) < 20:
				_sp(img,x, y, DARK_GREEN)
	if not is_back:
		_sp(img,9, y_off + 7, Color(0.8, 0.1, 0.1))
		_sp(img,12, y_off + 7, Color(0.8, 0.1, 0.1))
	for x in range(7, 11): _sp(img,x, y_off + 14, body_color)
	for x in range(19, 23): _sp(img,x, y_off + 14, body_color)

static func _draw_ivysaur(img: Image, is_back: bool) -> void:
	_draw_bulbasaur(img, is_back)

static func _draw_charmander(img: Image, is_back: bool) -> void:
	var y_off = 4
	# Body - orange
	for y in range(y_off + 2, y_off + 16):
		for x in range(9, 23):
			if (x - 16) * (x - 16) + (y - (y_off + 10)) * (y - (y_off + 10)) < 60:
				_sp(img,x, y, ORANGE)
	# Head
	for y in range(y_off, y_off + 6):
		for x in range(11, 21):
			if (x - 16) * (x - 16) + (y - (y_off + 3)) * (y - (y_off + 3)) < 20:
				_sp(img,x, y, ORANGE)
	# Belly
	for y in range(y_off + 8, y_off + 14):
		for x in range(12, 20):
			if (x - 16) * (x - 16) + (y - (y_off + 11)) * (y - (y_off + 11)) < 15:
				_sp(img,x, y, Color(1.0, 0.9, 0.6))
	if not is_back:
		_sp(img,13, y_off + 2, BLACK)
		_sp(img,18, y_off + 2, BLACK)
	# Tail flame
	var tx = 22
	for i in range(4):
		_sp(img,tx + i, y_off + 12 - i, ORANGE)
		_sp(img,tx + i, y_off + 13 - i, Color(1, 0.5, 0))
	_sp(img,tx + 3, y_off + 8, Color(1, 0.2, 0))
	_sp(img,tx + 4, y_off + 8, YELLOW)

static func _draw_charmeleon(img: Image, is_back: bool) -> void:
	_draw_charmander(img, is_back)

static func _draw_squirtle(img: Image, is_back: bool) -> void:
	var y_off = 5
	var body_color = Color(0.4, 0.65, 0.95)
	# Shell
	for y in range(y_off + 4, y_off + 14):
		for x in range(8, 24):
			if (x - 16) * (x - 16) + (y - (y_off + 9)) * (y - (y_off + 9)) < 55:
				_sp(img,x, y, BROWN)
	# Body
	for y in range(y_off + 2, y_off + 14):
		for x in range(10, 22):
			if (x - 16) * (x - 16) + (y - (y_off + 8)) * (y - (y_off + 8)) < 36:
				_sp(img,x, y, body_color)
	# Head
	for y in range(y_off, y_off + 5):
		for x in range(11, 21):
			if (x - 16) * (x - 16) + (y - (y_off + 2)) * (y - (y_off + 2)) < 18:
				_sp(img,x, y, body_color)
	if not is_back:
		_sp(img,13, y_off + 1, BLACK)
		_sp(img,18, y_off + 1, BLACK)
	# Belly
	for y in range(y_off + 7, y_off + 13):
		for x in range(12, 20):
			if (x - 16) * (x - 16) + (y - (y_off + 10)) * (y - (y_off + 10)) < 14:
				_sp(img,x, y, Color(0.9, 0.85, 0.6))
	# Feet
	for x in range(10, 14): _sp(img,x, y_off + 14, body_color)
	for x in range(18, 22): _sp(img,x, y_off + 14, body_color)

static func _draw_wartortle(img: Image, is_back: bool) -> void:
	_draw_squirtle(img, is_back)

static func _draw_pidgey(img: Image, is_back: bool) -> void:
	var y_off = 6
	var body_color = Color(0.65, 0.5, 0.35)
	# Body
	for y in range(y_off + 2, y_off + 12):
		for x in range(9, 23):
			if (x - 16) * (x - 16) + (y - (y_off + 8)) * (y - (y_off + 8)) < 40:
				_sp(img,x, y, body_color)
	# Head
	for y in range(y_off, y_off + 5):
		for x in range(11, 21):
			if (x - 16) * (x - 16) + (y - (y_off + 2)) * (y - (y_off + 2)) < 18:
				_sp(img,x, y, body_color)
	# Cream belly
	for y in range(y_off + 6, y_off + 11):
		for x in range(12, 20):
			if (x - 16) * (x - 16) + (y - (y_off + 8)) * (y - (y_off + 8)) < 12:
				_sp(img,x, y, Color(0.95, 0.9, 0.75))
	if not is_back:
		_sp(img,13, y_off + 1, BLACK)
		_sp(img,14, y_off + 2, YELLOW)  # Beak
		# Wing lines
	for x in range(6, 10): _sp(img,x, y_off + 5, body_color)
	for x in range(22, 26): _sp(img,x, y_off + 5, body_color)

static func _draw_rattata(img: Image, is_back: bool) -> void:
	var y_off = 8
	var body_color = Color(0.6, 0.4, 0.65)
	# Body
	for y in range(y_off + 2, y_off + 10):
		for x in range(9, 23):
			if (x - 16) * (x - 16) + (y - (y_off + 6)) * (y - (y_off + 6)) < 35:
				_sp(img,x, y, body_color)
	# Head
	for y in range(y_off, y_off + 5):
		for x in range(10, 20):
			if (x - 16) * (x - 16) + (y - (y_off + 2)) * (y - (y_off + 2)) < 16:
				_sp(img,x, y, body_color)
	# Ears
	_sp(img,11, y_off - 1, body_color)
	_sp(img,12, y_off - 1, body_color)
	_sp(img,19, y_off - 1, body_color)
	_sp(img,20, y_off - 1, body_color)
	if not is_back:
		_sp(img,12, y_off + 1, BLACK)
		_sp(img,17, y_off + 1, BLACK)
		# Teeth
		_sp(img,14, y_off + 3, WHITE)
		_sp(img,15, y_off + 3, WHITE)
	# Tail
	for i in range(6):
		_sp(img,22 + i/2, y_off + 4 - i, body_color)

static func _draw_caterpie(img: Image, is_back: bool) -> void:
	var y_off = 10
	var body_color = Color(0.3, 0.8, 0.3)
	# Segmented body
	for seg in range(5):
		for y in range(y_off + 2, y_off + 6):
			for x in range(7 + seg * 3, 10 + seg * 3):
				_sp(img,x, y, body_color)
	# Head
	for y in range(y_off, y_off + 5):
		for x in range(5, 9):
			_sp(img,x, y, body_color)
	# Horn
	_sp(img,6, y_off - 1, Color(1, 0.3, 0.3))
	if not is_back:
		_sp(img,5, y_off + 1, BLACK)

static func _draw_geodude(img: Image, is_back: bool) -> void:
	var y_off = 6
	# Rock body
	for y in range(y_off, y_off + 14):
		for x in range(7, 25):
			if (x - 16) * (x - 16) + (y - (y_off + 7)) * (y - (y_off + 7)) < 55:
				_sp(img,x, y, GRAY)
	# Darker rock texture
	for y in range(y_off + 2, y_off + 12):
		for x in range(9, 23):
			if (x + y) % 5 == 0:
				_sp(img,x, y, DARK_GRAY)
	# Arms
	for i in range(5):
		_sp(img,5 - i, y_off + 6 + i, GRAY)
		_sp(img,6 - i, y_off + 6 + i, GRAY)
		_sp(img,26 + i, y_off + 6 + i, GRAY)
		_sp(img,27 + i, y_off + 6 + i, GRAY)
	if not is_back:
		_sp(img,12, y_off + 4, BLACK)
		_sp(img,19, y_off + 4, BLACK)
		# Brow
		for x in range(11, 14): _sp(img,x, y_off + 3, DARK_GRAY)
		for x in range(18, 21): _sp(img,x, y_off + 3, DARK_GRAY)

static func _draw_zubat(img: Image, is_back: bool) -> void:
	var y_off = 4
	var body_color = Color(0.45, 0.35, 0.7)
	# Body
	for y in range(y_off + 4, y_off + 14):
		for x in range(12, 20):
			if (x - 16) * (x - 16) + (y - (y_off + 9)) * (y - (y_off + 9)) < 25:
				_sp(img,x, y, body_color)
	# Head
	for y in range(y_off + 2, y_off + 6):
		for x in range(13, 19):
			_sp(img,x, y, body_color)
	# Ears
	_sp(img,13, y_off + 1, body_color)
	_sp(img,14, y_off, body_color)
	_sp(img,18, y_off + 1, body_color)
	_sp(img,17, y_off, body_color)
	# Wings
	for i in range(8):
		for j in range(3):
			_sp(img,4 + i, y_off + 4 + j + i/3, body_color)
			_sp(img,24 - i, y_off + 4 + j + i/3, body_color)
	if not is_back:
		# Mouth
		_sp(img,15, y_off + 4, BLACK)
		_sp(img,16, y_off + 4, BLACK)

static func _draw_oddish(img: Image, is_back: bool) -> void:
	var y_off = 4
	var body_color = Color(0.3, 0.45, 0.85)
	# Leaves on top
	for i in range(5):
		var lx = 13 + i * 2 - 4
		for j in range(5):
			_sp(img,lx, y_off + j, GREEN)
			_sp(img,lx + 1, y_off + j, GREEN)
	# Body
	for y in range(y_off + 5, y_off + 16):
		for x in range(8, 24):
			if (x - 16) * (x - 16) + (y - (y_off + 11)) * (y - (y_off + 11)) < 45:
				_sp(img,x, y, body_color)
	if not is_back:
		_sp(img,12, y_off + 9, Color(0.8, 0.2, 0.2))
		_sp(img,19, y_off + 9, Color(0.8, 0.2, 0.2))
	# Feet
	_sp(img,12, y_off + 16, body_color)
	_sp(img,13, y_off + 16, body_color)
	_sp(img,18, y_off + 16, body_color)
	_sp(img,19, y_off + 16, body_color)

static func _draw_mankey(img: Image, is_back: bool) -> void:
	var y_off = 4
	var body_color = Color(0.9, 0.8, 0.65)
	# Body
	for y in range(y_off + 4, y_off + 14):
		for x in range(9, 23):
			if (x - 16) * (x - 16) + (y - (y_off + 9)) * (y - (y_off + 9)) < 40:
				_sp(img,x, y, body_color)
	# Head (round, piglike nose)
	for y in range(y_off, y_off + 6):
		for x in range(11, 21):
			if (x - 16) * (x - 16) + (y - (y_off + 3)) * (y - (y_off + 3)) < 20:
				_sp(img,x, y, body_color)
	# Tuft of hair
	_sp(img,15, y_off - 1, body_color)
	_sp(img,16, y_off - 1, body_color)
	_sp(img,15, y_off - 2, body_color)
	if not is_back:
		_sp(img,13, y_off + 2, BLACK)
		_sp(img,18, y_off + 2, BLACK)
		_sp(img,15, y_off + 3, Color(0.85, 0.55, 0.4))
		_sp(img,16, y_off + 3, Color(0.85, 0.55, 0.4))
	# Arms
	for i in range(4):
		_sp(img,7 - i, y_off + 7 + i, body_color)
		_sp(img,24 + i, y_off + 7 + i, body_color)
	# Feet
	for x in range(10, 14): _sp(img,x, y_off + 14, body_color)
	for x in range(18, 22): _sp(img,x, y_off + 14, body_color)

static func _draw_gastly(img: Image, is_back: bool) -> void:
	var y_off = 4
	# Gas cloud (dark purple, semi-transparent look)
	for y in range(y_off, y_off + 20):
		for x in range(4, 28):
			var dist = (x - 16) * (x - 16) + (y - (y_off + 10)) * (y - (y_off + 10))
			if dist < 100:
				if (x + y) % 3 != 0:
					_sp(img,x, y, Color(0.25, 0.1, 0.35, 0.8))
	# Inner sphere (darker)
	for y in range(y_off + 4, y_off + 14):
		for x in range(10, 22):
			if (x - 16) * (x - 16) + (y - (y_off + 9)) * (y - (y_off + 9)) < 30:
				_sp(img,x, y, Color(0.15, 0.05, 0.25))
	if not is_back:
		# Eyes (white)
		_sp(img,13, y_off + 7, WHITE)
		_sp(img,14, y_off + 7, WHITE)
		_sp(img,18, y_off + 7, WHITE)
		_sp(img,19, y_off + 7, WHITE)
		# Pupils
		_sp(img,14, y_off + 8, BLACK)
		_sp(img,19, y_off + 8, BLACK)
		# Mouth
		_sp(img,14, y_off + 10, Color(0.8, 0.2, 0.3))
		_sp(img,15, y_off + 11, Color(0.8, 0.2, 0.3))
		_sp(img,16, y_off + 11, Color(0.8, 0.2, 0.3))
		_sp(img,17, y_off + 10, Color(0.8, 0.2, 0.3))

static func _draw_onix(img: Image, is_back: bool) -> void:
	var y_off = 2
	# Segments of rocky body
	var seg_positions = [
		Vector2(16, y_off + 4),
		Vector2(14, y_off + 8),
		Vector2(17, y_off + 12),
		Vector2(13, y_off + 16),
		Vector2(16, y_off + 20),
	]
	for i in range(seg_positions.size()):
		var pos = seg_positions[i]
		var radius = 5 - i * 0.5
		for y in range(int(pos.y - radius), int(pos.y + radius)):
			for x in range(int(pos.x - radius), int(pos.x + radius)):
				if x >= 0 and x < 32 and y >= 0 and y < 32:
					if (x - pos.x) * (x - pos.x) + (y - pos.y) * (y - pos.y) < radius * radius:
						_sp(img,x, y, GRAY)
	# Head detail
	if not is_back:
		_sp(img,14, y_off + 3, BLACK)
		_sp(img,18, y_off + 3, BLACK)
		# Horn
		_sp(img,16, y_off, GRAY)
		_sp(img,16, y_off - 1, DARK_GRAY)

static func _draw_generic_pokemon(img: Image, is_back: bool) -> void:
	# Generic pokeball shape placeholder
	var y_off = 6
	for y in range(y_off, y_off + 20):
		for x in range(6, 26):
			if (x - 16) * (x - 16) + (y - (y_off + 10)) * (y - (y_off + 10)) < 80:
				if y < y_off + 10:
					_sp(img,x, y, Color(0.9, 0.2, 0.2))
				else:
					_sp(img,x, y, WHITE)
	# Center line
	for x in range(6, 26):
		_sp(img,x, y_off + 10, BLACK)
	# Center circle
	for y in range(y_off + 8, y_off + 13):
		for x in range(14, 19):
			if (x - 16) * (x - 16) + (y - (y_off + 10)) * (y - (y_off + 10)) < 6:
				_sp(img,x, y, WHITE)

# Tile sprites (16x16)
static func create_tile(tile_type: String) -> ImageTexture:
	var img = Image.create(16, 16, false, Image.FORMAT_RGBA8)

	match tile_type:
		"grass":
			img.fill(Color(0.35, 0.7, 0.3))
			# Add grass detail
			for i in range(8):
				var gx = randi() % 14 + 1
				var gy = randi() % 14 + 1
				_sp(img,gx, gy, Color(0.25, 0.6, 0.2))
		"tall_grass":
			img.fill(Color(0.3, 0.65, 0.25))
			for x in range(0, 16, 3):
				for y in range(0, 16, 4):
					_sp(img,x, y, Color(0.2, 0.55, 0.15))
					if y > 0: _sp(img,x, y - 1, Color(0.2, 0.55, 0.15))
					if x + 1 < 16: _sp(img,x + 1, y, Color(0.25, 0.58, 0.18))
		"water":
			img.fill(Color(0.3, 0.5, 0.9))
			for i in range(4):
				var wx = randi() % 12 + 2
				var wy = randi() % 12 + 2
				_sp(img,wx, wy, Color(0.5, 0.7, 1.0))
				_sp(img,wx + 1, wy, Color(0.5, 0.7, 1.0))
		"path":
			img.fill(Color(0.82, 0.72, 0.55))
			for i in range(6):
				var px = randi() % 14 + 1
				var py = randi() % 14 + 1
				_sp(img,px, py, Color(0.75, 0.65, 0.48))
		"wall":
			img.fill(Color(0.5, 0.45, 0.4))
			# Brick pattern
			for y in range(0, 16, 4):
				for x in range(0, 16):
					_sp(img,x, y, Color(0.4, 0.35, 0.3))
			for y in range(0, 16, 8):
				_sp(img,8, y + 1, Color(0.4, 0.35, 0.3))
				_sp(img,8, y + 2, Color(0.4, 0.35, 0.3))
				_sp(img,8, y + 3, Color(0.4, 0.35, 0.3))
		"floor":
			img.fill(Color(0.85, 0.8, 0.7))
			for y in range(0, 16, 8):
				for x in range(0, 16):
					_sp(img,x, y, Color(0.75, 0.7, 0.6))
			for x in range(0, 16, 8):
				for y in range(0, 16):
					_sp(img,x, y, Color(0.75, 0.7, 0.6))
		"tree":
			img.fill(Color(0.35, 0.7, 0.3))
			# Tree trunk
			for y in range(10, 16):
				for x in range(6, 10):
					_sp(img,x, y, BROWN)
			# Leaves
			for y in range(1, 11):
				for x in range(2, 14):
					if (x - 8) * (x - 8) + (y - 5) * (y - 5) < 25:
						_sp(img,x, y, DARK_GREEN)
		"roof":
			img.fill(Color(0.7, 0.3, 0.25))
			for y in range(0, 16, 2):
				for x in range(0, 16):
					if (x + y/2) % 4 == 0:
						_sp(img,x, y, Color(0.6, 0.25, 0.2))
		"door":
			img.fill(Color(0.55, 0.35, 0.2))
			# Door frame
			for y in range(0, 16):
				_sp(img,0, y, Color(0.65, 0.45, 0.3))
				_sp(img,15, y, Color(0.65, 0.45, 0.3))
			for x in range(0, 16):
				_sp(img,x, 0, Color(0.65, 0.45, 0.3))
			# Doorknob
			_sp(img,12, 8, YELLOW)
			_sp(img,12, 9, YELLOW)
		"sign":
			img.fill(Color(0.35, 0.7, 0.3))
			# Sign post
			for y in range(8, 16):
				_sp(img,7, y, BROWN)
				_sp(img,8, y, BROWN)
			# Sign board
			for y in range(2, 9):
				for x in range(3, 13):
					_sp(img,x, y, Color(0.75, 0.65, 0.45))
		"fence":
			img.fill(Color(0.35, 0.7, 0.3))
			# Fence posts and rails
			for y in range(4, 14):
				_sp(img,2, y, BROWN)
				_sp(img,7, y, BROWN)
				_sp(img,13, y, BROWN)
			for x in range(2, 14):
				_sp(img,x, 6, BROWN)
				_sp(img,x, 10, BROWN)
		_:
			img.fill(Color(0.3, 0.3, 0.3))

	return ImageTexture.create_from_image(img)

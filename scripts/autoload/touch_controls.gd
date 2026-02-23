extends CanvasLayer
## Mobile touch controls - virtual D-pad and action buttons for touchscreen devices.

var is_mobile: bool = false
var draw_node: TouchDrawNode

func _ready() -> void:
	layer = 100
	_detect_mobile()
	if is_mobile:
		draw_node = TouchDrawNode.new()
		draw_node.controls = self
		add_child(draw_node)

func _detect_mobile() -> void:
	var os_name = OS.get_name()
	if os_name in ["Android", "iOS"]:
		is_mobile = true
	elif os_name == "Web":
		is_mobile = true
	if not is_mobile:
		var vp_size = get_viewport().get_visible_rect().size
		if vp_size.x <= 1024:
			is_mobile = true


class TouchDrawNode extends Control:
	var controls: Node

	# Layout
	var dpad_center: Vector2
	var dpad_radius: float = 36.0
	var dpad_outer_radius: float = 52.0
	var button_radius: float = 20.0
	var btn_a_pos: Vector2
	var btn_b_pos: Vector2
	var btn_start_pos: Vector2

	# Touch tracking
	var dpad_touch_index: int = -1
	var current_direction: Vector2 = Vector2.ZERO
	var a_touch_index: int = -1
	var b_touch_index: int = -1
	var start_touch_index: int = -1

	# Colors
	var bg_color: Color = Color(0, 0, 0, 0.3)
	var active_color: Color = Color(1, 1, 1, 0.5)
	var dpad_color: Color = Color(0.2, 0.2, 0.2, 0.5)
	var dpad_arrow_color: Color = Color(0.9, 0.9, 0.9, 0.6)
	var btn_a_color: Color = Color(0.2, 0.6, 0.2, 0.5)
	var btn_b_color: Color = Color(0.7, 0.2, 0.2, 0.5)
	var btn_start_color: Color = Color(0.4, 0.4, 0.4, 0.5)

	func _ready() -> void:
		set_anchors_preset(PRESET_FULL_RECT)
		mouse_filter = MOUSE_FILTER_PASS
		_update_positions()

	func _update_positions() -> void:
		var vp = get_viewport_rect().size
		var scale_factor = maxf(vp.x / 320.0, 1.0)
		dpad_radius = 36.0 * scale_factor
		dpad_outer_radius = 52.0 * scale_factor
		button_radius = 20.0 * scale_factor

		var margin = 20.0 * scale_factor
		var bottom_offset = 70.0 * scale_factor

		dpad_center = Vector2(margin + dpad_outer_radius, vp.y - bottom_offset)

		var btn_x = vp.x - margin - button_radius
		var btn_y = vp.y - bottom_offset
		btn_a_pos = Vector2(btn_x, btn_y - button_radius * 1.2)
		btn_b_pos = Vector2(btn_x - button_radius * 2.5, btn_y)
		btn_start_pos = Vector2(vp.x / 2.0, vp.y - margin - button_radius * 0.6)

	func _input(event: InputEvent) -> void:
		if event is InputEventScreenTouch:
			_handle_touch(event)
		elif event is InputEventScreenDrag:
			_handle_drag(event)

	func _handle_touch(event: InputEventScreenTouch) -> void:
		if event.pressed:
			if event.position.distance_to(dpad_center) < dpad_outer_radius:
				dpad_touch_index = event.index
				_update_dpad_direction(event.position)
				get_viewport().set_input_as_handled()
				return
			if event.position.distance_to(btn_a_pos) < button_radius * 1.5:
				a_touch_index = event.index
				Input.action_press("ui_accept")
				get_viewport().set_input_as_handled()
				return
			if event.position.distance_to(btn_b_pos) < button_radius * 1.5:
				b_touch_index = event.index
				Input.action_press("ui_cancel")
				get_viewport().set_input_as_handled()
				return
			if event.position.distance_to(btn_start_pos) < button_radius * 2.0:
				start_touch_index = event.index
				Input.action_press("menu")
				get_viewport().set_input_as_handled()
				return
		else:
			if event.index == dpad_touch_index:
				dpad_touch_index = -1
				_release_all_directions()
			if event.index == a_touch_index:
				a_touch_index = -1
				Input.action_release("ui_accept")
			if event.index == b_touch_index:
				b_touch_index = -1
				Input.action_release("ui_cancel")
			if event.index == start_touch_index:
				start_touch_index = -1
				Input.action_release("menu")

	func _handle_drag(event: InputEventScreenDrag) -> void:
		if event.index == dpad_touch_index:
			_update_dpad_direction(event.position)

	func _update_dpad_direction(touch_pos: Vector2) -> void:
		var dir = (touch_pos - dpad_center).normalized()
		var new_direction: Vector2
		if abs(dir.x) > abs(dir.y):
			new_direction = Vector2.RIGHT if dir.x > 0 else Vector2.LEFT
		else:
			new_direction = Vector2.DOWN if dir.y > 0 else Vector2.UP

		if new_direction != current_direction:
			_release_all_directions()
			current_direction = new_direction
			var action = _dir_to_action(current_direction)
			if action != "":
				Input.action_press(action)

	func _release_all_directions() -> void:
		for action in ["move_up", "move_down", "move_left", "move_right"]:
			if Input.is_action_pressed(action):
				Input.action_release(action)
		current_direction = Vector2.ZERO

	func _dir_to_action(dir: Vector2) -> String:
		if dir == Vector2.UP: return "move_up"
		if dir == Vector2.DOWN: return "move_down"
		if dir == Vector2.LEFT: return "move_left"
		if dir == Vector2.RIGHT: return "move_right"
		return ""

	func _process(_delta: float) -> void:
		_update_positions()
		queue_redraw()

	func _draw() -> void:
		# D-pad background
		draw_circle(dpad_center, dpad_outer_radius, bg_color)

		# D-pad cross
		var cross_w = dpad_radius * 0.4
		var cross_l = dpad_radius * 0.8
		var dpad_col = active_color if dpad_touch_index >= 0 else dpad_color
		draw_rect(Rect2(dpad_center.x - cross_w, dpad_center.y - cross_l, cross_w * 2, cross_l * 2), dpad_col)
		draw_rect(Rect2(dpad_center.x - cross_l, dpad_center.y - cross_w, cross_l * 2, cross_w * 2), dpad_col)

		# Direction arrows
		_draw_arrow(dpad_center + Vector2(0, -cross_l * 0.6), Vector2.UP, current_direction == Vector2.UP)
		_draw_arrow(dpad_center + Vector2(0, cross_l * 0.6), Vector2.DOWN, current_direction == Vector2.DOWN)
		_draw_arrow(dpad_center + Vector2(-cross_l * 0.6, 0), Vector2.LEFT, current_direction == Vector2.LEFT)
		_draw_arrow(dpad_center + Vector2(cross_l * 0.6, 0), Vector2.RIGHT, current_direction == Vector2.RIGHT)

		# A button
		var a_col = active_color if a_touch_index >= 0 else btn_a_color
		draw_circle(btn_a_pos, button_radius, a_col)
		_draw_label(btn_a_pos, "A")

		# B button
		var b_col = active_color if b_touch_index >= 0 else btn_b_color
		draw_circle(btn_b_pos, button_radius, b_col)
		_draw_label(btn_b_pos, "B")

		# START button
		var start_col = active_color if start_touch_index >= 0 else btn_start_color
		var sw = button_radius * 2.2
		var sh = button_radius * 0.7
		draw_rect(Rect2(btn_start_pos.x - sw / 2, btn_start_pos.y - sh / 2, sw, sh), start_col, true)
		_draw_label(btn_start_pos, "START")

	func _draw_arrow(pos: Vector2, dir: Vector2, is_active: bool) -> void:
		var color = Color.WHITE if is_active else dpad_arrow_color
		var s = dpad_radius * 0.2
		var pts: PackedVector2Array
		if dir == Vector2.UP:
			pts = PackedVector2Array([pos + Vector2(-s, s * 0.5), pos + Vector2(0, -s * 0.5), pos + Vector2(s, s * 0.5)])
		elif dir == Vector2.DOWN:
			pts = PackedVector2Array([pos + Vector2(-s, -s * 0.5), pos + Vector2(0, s * 0.5), pos + Vector2(s, -s * 0.5)])
		elif dir == Vector2.LEFT:
			pts = PackedVector2Array([pos + Vector2(s * 0.5, -s), pos + Vector2(-s * 0.5, 0), pos + Vector2(s * 0.5, s)])
		elif dir == Vector2.RIGHT:
			pts = PackedVector2Array([pos + Vector2(-s * 0.5, -s), pos + Vector2(s * 0.5, 0), pos + Vector2(-s * 0.5, s)])
		if pts.size() > 0:
			draw_colored_polygon(pts, color)

	func _draw_label(pos: Vector2, text: String) -> void:
		var font = ThemeDB.fallback_font
		var fs = int(button_radius * 0.7)
		var ts = font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, fs)
		draw_string(font, pos - Vector2(ts.x / 2, -ts.y / 4), text, HORIZONTAL_ALIGNMENT_CENTER, -1, fs, Color.WHITE)

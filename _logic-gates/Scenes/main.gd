extends Node2D

var is_hovering_area: bool = false
var current_area_name: String = ""
var previous_area_name: String = ""
var hover_position: Vector2 = Vector2()
var start_draw_position: Vector2 = Vector2()
var current_draw_position: Vector2 = Vector2()
var is_drawing_line: bool = false
var line_segments: Array[Line2D] = []
var area_connections: Dictionary = {}
var active_line_name: String = ""

func _ready() -> void:
	for child in get_children():
		if child is Area2D: 
			for grandchild in child.get_children(): 
				if grandchild is Area2D:  
					grandchild.connect("is_mouse_entered", Callable(self, "_on_area_mouse_entered"))
					grandchild.connect("is_mouse_exited", Callable(self, "_on_area_mouse_exited"))

func _on_area_mouse_entered(area_name: String, position_mouse: Vector2) -> void:
	current_area_name = area_name
	is_hovering_area = true
	hover_position = position_mouse

func _on_area_mouse_exited() -> void:
	is_hovering_area = false

func _process(_delta: float) -> void:
	if is_drawing_line and line_segments:
		current_draw_position = get_global_mouse_position()
		update_active_line()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if is_hovering_area and event.is_pressed() and not is_drawing_line:
			previous_area_name = current_area_name
			start_draw_position = hover_position
			active_line_name = create_new_line()
			is_drawing_line = true
		elif is_hovering_area and event.is_released():
			if is_drawing_line:
				if current_area_name != previous_area_name and not has_connection(current_area_name, previous_area_name):
					add_connection(active_line_name, current_area_name, previous_area_name)
				elif has_connection(current_area_name, previous_area_name):
					delete_active_line()
				elif current_area_name == previous_area_name:
					delete_connections_for_area(current_area_name)
					delete_active_line()
			is_drawing_line = false
		else:
			delete_active_line()

func add_connection(line_name: String, area_a: String, area_b: String) -> void:
	if not area_connections.has(line_name):
		area_connections[line_name] = [area_a, area_b]
	print(area_connections)

func create_new_line() -> String:
	var line: Line2D = Line2D.new()
	line.width = 2
	line.default_color = Color(0, 0, 0)
	line.add_point(start_draw_position)
	line.add_point(start_draw_position)
	add_child(line)
	line_segments.append(line)
	return line.name

func update_active_line() -> void:
	if line_segments and is_drawing_line:
		var last_line: Line2D = line_segments[line_segments.size() - 1]
		if is_hovering_area and not has_connection(current_area_name, previous_area_name):
			last_line.set_point_position(1, hover_position)
		else:
			last_line.set_point_position(1, current_draw_position)

func delete_active_line() -> void:
	if line_segments and is_drawing_line:
		var last_line = line_segments.pop_back()
		if last_line:
			last_line.queue_free()
		is_drawing_line = false

func delete_connections_for_area(area_name: String) -> void:
	var keys_to_remove: Array[String] = []
	for line_name in area_connections:
		if area_name in area_connections[line_name]:
			print("K")
			var line_node = get_node_or_null(line_name)
			if line_node:
				line_node.queue_free()
			keys_to_remove.append(line_name)
	
	for key in keys_to_remove:
		area_connections.erase(key)

func has_connection(area_a: String, area_b: String) -> bool:
	for line_name in area_connections:
		if area_a in area_connections[line_name] and area_b in area_connections[line_name]:
			return true
	return false

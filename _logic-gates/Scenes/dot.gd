extends Area2D

var current_area_name: String = name+"#"+str($".".get_instance_id())
var hover_position: Vector2 = global_position
var is_drawing_line: bool = false

## Deklarácia signálu
signal is_mouse_entered
signal is_mouse_exited
signal create_line

func _on_mouse_entered():
	emit_signal("is_mouse_entered", name+"#"+str($".".get_instance_id()), global_position)

func _on_mouse_exited():
	emit_signal("is_mouse_exited")


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("create_line")
			is_drawing_line = true
		#elif is_hovering_area and event.is_released():
			#if is_drawing_line:
				#if current_area_name != previous_area_name and not has_connection(current_area_name, previous_area_name):
					#add_connection(active_line_name, current_area_name, previous_area_name)
				#elif current_area_name == previous_area_name:
					#delete_connections_for_area(current_area_name)
					#print(area_connections)
					#delete_active_line()
				#elif has_connection(current_area_name, previous_area_name):
					#delete_active_line()

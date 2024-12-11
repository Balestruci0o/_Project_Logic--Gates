extends Area2D
#
## Deklarácia signálu
signal is_mouse_entered
signal is_mouse_exited

func _on_mouse_entered():
	emit_signal("is_mouse_entered", name+"#"+str($".".get_instance_id()), global_position)

func _on_mouse_exited():
	emit_signal("is_mouse_exited")

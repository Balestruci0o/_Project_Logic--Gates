extends Area2D

# Deklarácia signálu
signal is_mouse_entered
signal is_mouse_exited

func _on_mouse_entered():
	print("j")
	emit_signal("is_mouse_entered", name, global_position)

func _on_mouse_exited():
	emit_signal("is_mouse_exited")

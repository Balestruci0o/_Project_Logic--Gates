extends Area2D

var ele = false

signal spinac_on

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			ele = !ele
			emit_signal("spinac_on", ele)

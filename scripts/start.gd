extends Node3D
class_name start


func _on_start_01_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	):
		SignalBus.startClicked.emit(%spawn.global_position)

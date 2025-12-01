extends RigidBody3D
class_name Marble

var is_moving = true

func _process(_delta: float) -> void:
	if linear_velocity.length() < 20:
		is_moving = false
		SignalBus.marbleStopped.emit(self)
	else:
		is_moving = true

extends RigidBody3D
class_name Marble

const STOPPED_VELOCITY = 0.005
const SETTLE_TIME = 1.0
var is_moving = true
var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = SETTLE_TIME
	timer.timeout.connect(_stopped)
	timer.one_shot = true
	add_child(timer)

func _process(_delta: float) -> void:
	if linear_velocity.length() < STOPPED_VELOCITY:
		if (is_moving):
			is_moving = false
			timer.start()
	else:
		if (!is_moving):
			is_moving = true
			timer.stop()

func _stopped():
	SignalBus.marbleStopped.emit(self)

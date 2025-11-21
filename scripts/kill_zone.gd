extends Area3D

func _ready() -> void:
	connect("body_shape_entered", _on_body_shape_entered)

func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int):
	if body.is_in_group('marble'):
		body.queue_free()

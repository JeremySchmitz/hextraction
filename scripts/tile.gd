extends Node3D
class_name tile

@export var config: TileResource
@onready var synschronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer


var tileRotation := 0.0 :
	set(val):
		rotation.y = val
	get():
		return rotation.y


func _ready() -> void:
	synschronizer.public_visibility = false


func syncing():
	synschronizer.public_visibility = true
	

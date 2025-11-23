extends Control
class_name TileCard



@onready var title: Label = %name
@onready var tileMarker: Marker3D = %tilePosition

@export var tileResource: TileResource :
	set(val):
		tileResource = val
		_initialize()


var isReady = false

func _ready() -> void:
	isReady = true
	_initialize()


func _initialize():
	if isReady:
		title.text = tileResource.name
		var model = TileDeck.TILE_LIST[tileResource.tileType]
		tileMarker.add_child(model.instantiate())


func _on_button_pressed() -> void:
	SignalBus.tileCardClicked.emit(tileResource)

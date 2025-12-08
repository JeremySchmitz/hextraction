extends Node
class_name Player

var hand: Array[TileCard] = []
var playerId: int = -1

func _ready() -> void:
	multiplayer.peer_connected.connect(setPlayer)


func removeCard(tile: String):
	var i = hand.find(tile)

func setPlayer(_peerId: int) -> void:
	var id = multiplayer.multiplayer_peer.get_unique_id()
	playerId = id
	var listPlayer := ListPlayer.new()
	listPlayer.id = id
	listPlayer.name = _generateName()
	Stack.addPlayer(listPlayer)
	SignalBus.playerSet.emit(listPlayer)
	multiplayer.peer_connected.disconnect(setPlayer)
	Stack.thisPlayer = self

func _generateName():
	var n = ""
	for i in 3:
		var letter = char("A".unicode_at(0) + randi() % 26)
		n += letter
	return n

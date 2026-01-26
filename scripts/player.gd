extends Node
class_name Player

var playerId: int = -1
var playerName: String

func _init(n = '') -> void:
	playerName = n

func _ready() -> void:
	multiplayer.peer_connected.connect(setPlayer)


func setPlayer(_peerId: int) -> void:
	var id = multiplayer.multiplayer_peer.get_unique_id()
	playerId = id
	var listPlayer := ListPlayer.new()
	listPlayer.id = id
	listPlayer.name = playerName
	Stack.addPlayer(listPlayer)
	SignalBus.playerSet.emit(listPlayer)
	multiplayer.peer_connected.disconnect(setPlayer)
	Stack.thisPlayer = self

func setPlayerName(n: String):
	playerName = n

extends Node

var selectedTile: String:
	set(val):
		selectedTile = val

var deck: Array[TileResource] = []

var curentPlayer := 0
var thisPlayer: Player
var playerList: Array[ListPlayer] = []

func addPlayer(player: ListPlayer):
	if !multiplayer.is_server():
		rpc_id(1, "_addPlayer", player.id, player.name)

	else:
		_addPlayer(player.id, player.name)

@rpc("any_peer")
func _addPlayer(id: int, playerName: String):
	var exists = playerList.find_custom(func(player): return player.id == id)
	if exists == -1:
		var player = ListPlayer.new()
		player.id = id
		player.name = playerName
		playerList.append(player)
		SignalBus.playerSet.emit(player)
		
func nextTurn():
	print('nextTurn')
	if curentPlayer == playerList.size() - 1:
		curentPlayer = 0
	else:
		curentPlayer = curentPlayer + 1
		
	SignalBus.turnChanged.emit(playerList[curentPlayer])

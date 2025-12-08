extends Node

var isConnected = false

var selectedTile: String:
	set(val):
		selectedTile = val

var deck: Array[TileResource] = []
var gameStarted := false
var curentPlayer := 0
var currentPlayerId := -1

var thisPlayer: Player
var playerList: Array[ListPlayer] = []

func _ready() -> void:
	multiplayer.peer_connected.connect(_onConnected)
	SignalBus.startGame.connect(onStartGame)

func _input(event: InputEvent) -> void:
	var isMouse = (
			event is InputEventMouseButton
			and event.button_index == MOUSE_BUTTON_LEFT
			and event.pressed)
	if thisPlayer && isConnected:
		if !isMouse: return
		var isPlayerTurn = thisPlayer.playerId == currentPlayerId
		if (gameStarted && !isPlayerTurn):
			get_viewport().set_input_as_handled()
	

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
		
func onStartGame():
	rpc("_onStartGame")
	_onStartGame()

@rpc("any_peer")
func _onStartGame():
	print('startGame')
	gameStarted = true
	if multiplayer.is_server(): updateCurrentPlayerTag()
	if multiplayer.is_server(): updateCurrentPlayerId()


func nextTurn():
	if !multiplayer.is_server():
		rpc_id(1, "_nextTurn")
	else:
		_nextTurn()

@rpc("any_peer")
func _nextTurn():
	if curentPlayer == playerList.size() - 1:
		curentPlayer = 0
	else:
		curentPlayer = curentPlayer + 1

	print('next turn')
	if multiplayer.is_server(): updateCurrentPlayerTag()
	if multiplayer.is_server(): updateCurrentPlayerId()


func updateCurrentPlayerTag():
	rpc("_updateCurrentPlayerTag", playerList[curentPlayer].name)
	_updateCurrentPlayerTag(playerList[curentPlayer].name)

@rpc("any_peer")
func _updateCurrentPlayerTag(n: String):
	SignalBus.turnChanged.emit(n)


func updateCurrentPlayerId():
	rpc("_updateCurrentPlayerId", playerList[curentPlayer].id)
	_updateCurrentPlayerId(playerList[curentPlayer].id)

@rpc("any_peer")
func _updateCurrentPlayerId(id: int):
	currentPlayerId = id


@rpc("any_peer")
func _isPlayerTurn(id) -> bool:
	return id != null && id == playerList[curentPlayer].id


@rpc("any_peer")
func _getNextPlayer():
	return playerList[curentPlayer].name


func _onConnected(_peerId: int):
	isConnected = true

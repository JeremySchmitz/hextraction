extends Node

var isConnected = false

var selectedTile: String:
	set(val):
		selectedTile = val

var deck: Array[TileResource] = []
var gameStarted := false
var currentPlayerIdx := 0
var currentPlayerId := -1
var gameWon = false

var thisPlayer: Player
var playerList: Array[ListPlayer] = []

func _ready() -> void:
	multiplayer.peer_connected.connect(_onConnected)
	SignalBus.startGame.connect(onStartGame)
	SignalBus.tilePlayed.connect(_onTilePlayed)


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
	rpc("_addPlayer", player.id, player.name)
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
	if currentPlayerIdx == playerList.size() - 1:
		currentPlayerIdx = 0
	else:
		currentPlayerIdx = currentPlayerIdx + 1

	if multiplayer.is_server(): updateCurrentPlayerTag()
	if multiplayer.is_server(): updateCurrentPlayerId()


func updateCurrentPlayerTag():
	rpc("_updateCurrentPlayerTag", getCurrentPlayer().name)
	_updateCurrentPlayerTag(getCurrentPlayer().name)

@rpc("any_peer")
func _updateCurrentPlayerTag(n: String):
	SignalBus.turnChanged.emit(n)


func updateCurrentPlayerId():
	rpc("_updateCurrentPlayerId", getCurrentPlayer().id)
	_updateCurrentPlayerId(getCurrentPlayer().id)

@rpc("any_peer")
func _updateCurrentPlayerId(id: int):
	currentPlayerId = id


@rpc("any_peer")
func _isPlayerTurn(id) -> bool:
	return id != null && id == getCurrentPlayer().id


@rpc("any_peer")
func _getNextPlayer():
	return getCurrentPlayer().name


func _onConnected(_peerId: int):
	isConnected = true

func _onTilePlayed(_scenePath: String):
	# TODO case where no cards
	if deck.size() < 1: return

	rpc("_dealCard")
	_dealCard(true)
	

@rpc("any_peer")
func _dealCard(addToHand = false):
	var card: TileResource = deck.pop_front()

	if addToHand:
		SignalBus.tileDealt.emit(card)

func isTurn():
	if (!thisPlayer): return false
	return currentPlayerId == thisPlayer.playerId

func getCurrentPlayer():
	return playerList[currentPlayerIdx]

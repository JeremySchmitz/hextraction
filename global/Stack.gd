extends Node

var isConnected = false

var selectedTile: String:
	set(val):
		selectedTile = val

var deckSize := 40
var deck: Array[TileResource] = []
var gameStarted := false
var currentPlayerIdx := 0
var currentPlayerId := -1
var tilePlayed = false

var gameWon = false

var thisPlayer: Player
var playerList: Array[ListPlayer] = []

func _ready() -> void:
	multiplayer.peer_connected.connect(_onConnected)
	SignalBus.startGame.connect(onStartGame)
	SignalBus.tilePlayed.connect(_onTilePlayed)
	SignalBus.restartGame.connect(_resetGame)

func _resetGame():
	deck = []
	gameStarted = false
	currentPlayerIdx = 0
	tilePlayed = false
	gameWon = false
	selectedTile = ''

	if multiplayer.get_peers().size() and multiplayer.is_server():
		randomizePlayerList()
	

func reset():
	_resetGame()
	thisPlayer = null
	playerList = []
	

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

	
@rpc("any_peer")
func _sendPlayerName():
	rpc('_updatePlayerName', thisPlayer.playerId, thisPlayer.playerName)

@rpc("any_peer")
func _updatePlayerName(id: int, playerName: String):
	var i = playerList.find_custom(func(p): return p.id == id)
	var player: ListPlayer = playerList[i]
	if player: player.setPlayerName(playerName)
		
func onStartGame():
	if multiplayer.is_server():
		dealHand()
		_onStartGame(true)
		rpc("_onStartGame", false)

@rpc("any_peer")
func _onStartGame(randomizeList = false):
	if randomizeList:
		if !multiplayer.is_server():
			rpc_id(1, "randomizePlayerList")
		else: randomizePlayerList()
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

	tilePlayed = false

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

func updateCurrentPlayerIdx():
	rpc("_updateCurrentPlayerIdx", currentPlayerIdx)
	_updateCurrentPlayerId(currentPlayerIdx)

@rpc("any_peer")
func _updateCurrentPlayerIdx(idx: int):
	currentPlayerIdx = idx


@rpc("any_peer")
func _isPlayerTurn(id) -> bool:
	return id != null && id == getCurrentPlayer().id


@rpc("any_peer")
func _getNextPlayer():
	return getCurrentPlayer().name


func _onConnected(_peerId: int):
	isConnected = true

func _onTilePlayed(_scenePath: String):
	tilePlayed = true

	# TODO case where no cards
	if deck.size() < 1: return

	rpc("_dealCard")
	_dealCard(true)
	

@rpc("any_peer")
func _dealCard(addToHand = false):
	var card: TileResource = deck.pop_front()
	SignalBus.updateDeckCount.emit()

	if addToHand:
		SignalBus.tileDealt.emit(card)

func isTurn():
	if (!thisPlayer): return false
	return currentPlayerId == thisPlayer.playerId

func getCurrentPlayer():
	return playerList[currentPlayerIdx]


@rpc("any_peer")
func dealHand():
	if !multiplayer.is_server(): return

	for i in range(3):
		for player in playerList:
			if player.id == 1: _dealCard(true)
			else: rpc_id(player.id, '_dealCard', true)

			for player2 in playerList:
				if player2.id != player.id:
					if player2.id == 1: _dealCard(false)
					else: rpc_id(player2.id, '_dealCard', false)

func buildDeck():
	deck = TileDeck.buildDeck(deckSize)


@rpc("any_peer")
func randomizePlayerList():
	randomize()
	playerList.shuffle()
	var ids = playerList.map(func(p): return p.id)
	rpc('_randomizePlayerList', ids)

@rpc("authority")
func _randomizePlayerList(ids):
	var list: Array[ListPlayer] = []
	for id in ids:
		var player = playerList.find_custom(func(p): return p.id == id)
		list.append(playerList[player])

	playerList = list

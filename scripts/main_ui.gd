extends Control

const MAIN_MENU_PATH = 'res://scenes/main_menu.tscn'
const WIN_TEXT = "{0} has won!"
const NEXT_TURN_TEXT = "{0}'s Turn!"
const HIDE_TURN_TEXT_TIME = 3.0

var goalReached = false
var marbleInGoal = false

var turnTimer: Timer

var marbleDropped = false
var killMarbleCount = 0

func _ready() -> void:
	SignalBus.turnChanged.connect(setTurn)
	SignalBus.turnChanged.connect(on_turn_change)

	SignalBus.marbleInGoal.connect(_on_marble_in_goal)
	SignalBus.marbleStopped.connect(_on_marble_stopped)
	SignalBus.marbleKilled.connect(_on_marbled_killed)
	SignalBus.startAreaClicked.connect(_on_marble_dropped)

	SignalBus.updateDeckCount.connect(_update_deck_count)

	SignalBus.restartGame.connect(_reset)
	
	if (!multiplayer.is_server()):
		%start.hide()
		%PlayAgainBtn.hide()
	setPlayer(Stack.thisPlayer.playerName)

	_build_turn_timer()

func setTurn(playerName: String):
	%turn.text = 'Current Player: {0}'.format([playerName])

func setPlayer(playerName: String):
	%"this_player".text = playerName


func _on_start_pressed() -> void:
	%start.disabled = true
	%start.release_focus()
	rpc("_disable_start_button", true)
	if !multiplayer.is_server():
		rpc_id(1, "_start_pressed")
	else: SignalBus.startGame.emit()

@rpc("any_peer")
func _start_pressed():
	SignalBus.startGame.emit()

@rpc("any_peer")
func _disable_start_button(val: bool):
	%start.disabled = val


func on_turn_change(playerName: String):
	rpc("_on_turn_change", playerName)

@rpc("any_peer")
func _on_turn_change(playerName: String):
	%NextTurnBanner.text = NEXT_TURN_TEXT.format([playerName])
	%NextTurnBanner.show()

	turnTimer.start()


func _on_marble_in_goal(val: bool):
	marbleInGoal = val;

func _on_marble_stopped(_marble: Marble):
	if marbleInGoal: on_goal_reached()
	else: Stack.nextTurn()

func on_goal_reached():
	rpc("_on_goal_reached")

@rpc("any_peer")
func _on_goal_reached():
	Stack.gameWon = true
	_setWinnerBanner()

func _on_marbled_killed(_marble: Marble):
	rpc('marbleKilled')
	marbleKilled()
	Stack.nextTurn()

func _setWinnerBanner():
	%Winner_Banner.text = WIN_TEXT.format([Stack.getCurrentPlayer().name])
	%GameEndController.show()


func _build_turn_timer():
	turnTimer = Timer.new()
	turnTimer.wait_time = HIDE_TURN_TEXT_TIME
	turnTimer.timeout.connect(%NextTurnBanner.hide)
	turnTimer.one_shot = true
	add_child(turnTimer)

func _on_kill_marble_btn_pressed() -> void:
	if (!multiplayer.is_server()):
		rpc_id(1, 'incrementMarbleKillCount')
	else:
		incrementMarbleKillCount()

	%KillMarbleBtn.disabled = true
	

@rpc("any_peer")
func incrementMarbleKillCount():
	killMarbleCount = killMarbleCount + 1
	updateKillCountLabel()
	rpc('setMarbleKillCount', killMarbleCount)

	if killMarbleCount == Stack.playerList.size():
		SignalBus.killMarble.emit()

@rpc("authority")
func setMarbleKillCount(count: int):
	killMarbleCount = count
	updateKillCountLabel()

@rpc("authority")
func marbleKilled():
	killMarbleCount = 0
	updateKillCountLabel()
	rpc('_update_kill_btn', true)

func updateKillCountLabel():
	%KillMarbleCount.text = '{0}/{1}'.format([killMarbleCount, Stack.playerList.size()])


func _on_marble_dropped(_pos: Vector3):
	marbleDropped = true
	_update_kill_btn(false)
	rpc('_update_kill_btn', false)


@rpc("any_peer")
func _update_kill_btn(val: bool):
	%KillMarbleBtn.disabled = val

func _update_deck_count():
	%deck.text = 'Deck: {0}/{1}'.format([Stack.deck.size(), Stack.deckSize])


func _on_play_again_btn_pressed() -> void:
	rpc('_resetGame')
	_resetGame()


@rpc("any_peer")
func _resetGame():
	SignalBus.clearHand.emit()
	SignalBus.restartGame.emit()


func _on_main_menu_btn_pressed() -> void:
	_go_to_main_menu()


func _go_to_main_menu():
	var main_menu = get_node("/root/Main/MainMenu")
	var game = get_node("/root/Main/Game")
	main_menu.show()
	game.queue_free()
	Stack.reset()
	NetworkHandler.closePeer()

func _reset():
	goalReached = false
	marbleInGoal = false

	turnTimer.stop()

	marbleDropped = false
	killMarbleCount = 0

	%GameEndController.hide()
	%NextTurnBanner.hide()

	if (multiplayer.is_server()): %start.disabled = false

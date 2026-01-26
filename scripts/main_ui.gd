extends Control

const WIN_TEXT = "{0} has won!"
const NEXT_TURN_TEXT = "{0}'s Turn!"
const HIDE_TURN_TEXT_TIME = 3.0

var goalReached = false
var marbleInGoal = false

var turnTimer: Timer

func _ready() -> void:
	SignalBus.turnChanged.connect(setTurn)
	SignalBus.playerSet.connect(setPlayer)

	SignalBus.turnChanged.connect(on_turn_change)

	SignalBus.marbleInGoal.connect(_on_marble_in_goal)
	SignalBus.marbleStopped.connect(_on_marble_stopped)
	SignalBus.marbleKilled.connect(_on_marbled_killed)
	
	if (!multiplayer.is_server()): %start.hide()

	_build_turn_timer()

func setTurn(playerName: String):
	%turn.text = 'Current Player: {0}'.format([playerName])

func setPlayer(player: ListPlayer):
	%"this_player".text = '{0} {1}'.format([player.name, player.id])


func _on_start_pressed() -> void:
	SignalBus.startGame.emit()
	%start.disabled = true
	%start.release_focus()
	rpc("_disable_start_button", true)


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
	Stack.nextTurn()

func _setWinnerBanner():
	%Winner_Banner.text = WIN_TEXT.format([Stack.getCurrentPlayer().name])
	%Winner_Banner.show()


func _build_turn_timer():
	turnTimer = Timer.new()
	turnTimer.wait_time = HIDE_TURN_TEXT_TIME
	turnTimer.timeout.connect(%NextTurnBanner.hide)
	turnTimer.one_shot = true
	add_child(turnTimer)

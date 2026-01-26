extends Control

const WIN_TEXT = "{0} has won!"

var goalReached = false


func _ready() -> void:
	SignalBus.turnChanged.connect(setTurn)
	SignalBus.playerSet.connect(setPlayer)
	SignalBus.goalReached.connect(_on_goal_reached)
	
	if (!multiplayer.is_server()): %start.hide()

func setTurn(name: String):
	%turn.text = 'Current Player: {0}'.format([name])

func setPlayer(player: ListPlayer):
	%"this_player".text = '{0} {1}'.format([player.name, player.id])


func _on_start_pressed() -> void:
	SignalBus.startGame.emit()

func on_goal_reached():
	rpc("any_peer")


@rpc("any_peer")
func _on_goal_reached():
	Stack.gameWon = true
	_setWinnerBanner()


func _setWinnerBanner():
	%Winner_Banner.text = WIN_TEXT.format([Stack.getCurrentPlayer().name])
	%Winner_Banner.show()

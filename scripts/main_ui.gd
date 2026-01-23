extends Control

func _ready() -> void:
	SignalBus.turnChanged.connect(setTurn)
	SignalBus.playerSet.connect(setPlayer)
	
	if (!multiplayer.is_server()): %start.hide()

func setTurn(name: String):
	%turn.text = 'Current Player: {0}'.format([name])

func setPlayer(player: ListPlayer):
	%"this_player".text = '{0} {1}'.format([player.name, player.id])


func _on_start_pressed() -> void:
	SignalBus.startGame.emit()

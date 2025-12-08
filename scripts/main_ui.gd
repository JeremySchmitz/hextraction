extends Control

func _ready() -> void:
	SignalBus.turnChanged.connect(setTurn)
	SignalBus.playerSet.connect(setPlayer)

func setTurn(player: ListPlayer):
	%turn.text = 'Current Player: {0}'.format([player.name])

func setPlayer(player: ListPlayer):
	%"this_player".text = 'Current Player: {0}'.format([player.name])

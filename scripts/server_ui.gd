extends Control

func _on_server_pressed() -> void:
	Stack.thisPlayer = Player.new()
	Stack.thisPlayer.playerName = 'test'
	NetworkHandler.startServer()


func _on_client_pressed() -> void:
	Stack.thisPlayer = Player.new()
	Stack.thisPlayer.playerName = 'test'
	NetworkHandler.startClient('')

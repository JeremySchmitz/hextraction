extends Control

func _on_server_pressed() -> void:
	Stack.thisPlayer = Player.new()
	NetworkHandler.startServer()


func _on_client_pressed() -> void:
	Stack.thisPlayer = Player.new()
	NetworkHandler.startClient()

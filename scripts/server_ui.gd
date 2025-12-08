extends Control

func _on_server_pressed() -> void:
	NetworkHandler.startServer()
	Stack.thisPlayer = Player.new()


func _on_client_pressed() -> void:
	NetworkHandler.startClient()
	Stack.thisPlayer = Player.new()

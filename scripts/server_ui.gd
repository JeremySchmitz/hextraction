extends Control

func _on_server_pressed() -> void:
	NetworkHandler.startServer()


func _on_client_pressed() -> void:
	NetworkHandler.startClient()

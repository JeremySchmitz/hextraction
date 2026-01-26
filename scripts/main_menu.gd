extends Node2D

const MAIN_SCENE_PATH = 'res://scenes/game.tscn'


func _on_start_server_pressed() -> void:
	createPlayer()
	NetworkHandler.startServer()
	_go_to_game()


func _on_join_game_pressed() -> void:
	createPlayer()
	NetworkHandler.startClient(%ipAddress.text)
	_go_to_game()


func createPlayer():
	var player = Player.new(%playerName.text)
	Stack.thisPlayer = player

	
func _go_to_game():
	var scene = load(MAIN_SCENE_PATH).instantiate()
	get_parent().add_child(scene)
	scene.add_child(Stack.thisPlayer)
	self.hide()


func _on_ip_address_text_changed(new_text: String) -> void:
	%joinGame.disabled = !(new_text && %playerName.text)


func _on_player_name_text_changed(new_text: String) -> void:
	%startServer.disabled = !new_text
	%joinGame.disabled = !(new_text && %ipAddress.text)

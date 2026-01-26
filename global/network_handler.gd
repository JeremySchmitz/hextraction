extends Node

const IP_ADDRESS = 'localhost'
const PORT: int = 42069

var peer: ENetMultiplayerPeer

func startServer():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
func startClient(ipAddress: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ipAddress, PORT)
	multiplayer.multiplayer_peer = peer

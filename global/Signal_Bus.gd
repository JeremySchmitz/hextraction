extends Node

signal tileEntered(pos: Vector2)
signal tileExited(pos: Vector2)
signal tileClick(pos: Vector2)

signal tileConfirmed(pos:Vector3, rot:Vector3)
signal tileCanceled(pos:Vector2)

signal startClicked(pos:Vector3)

signal goalReached()
signal marbleStopped(marble: Marble)

signal tileCardClicked(rsc: TileResource)

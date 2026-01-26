extends Node

signal tileEntered(pos: Vector2)
signal tileExited(pos: Vector2)
signal tileClick(pos: Vector2)

signal tileConfirmed(pos: Vector3, rot: Vector3)
signal tileCanceled(pos: Vector2)

signal startAreaClicked(pos: Vector3)

signal marbleInGoal(val: bool)
signal marbleStopped(marble: Marble)
signal marbleKilled(marble: Marble)
signal killMarble()

signal tileCardClicked(rsc: TileResource)

signal turnChanged(player: ListPlayer)
signal playerSet(player: ListPlayer)

signal startGame()

signal tilePlayed(scenePath: String)
signal tileDealt(tile: TileResource)
signal updateDeckCount()
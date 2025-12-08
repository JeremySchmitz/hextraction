extends Node

enum TILE_TYPES {
	ASTERISK,
	BLIND_BOTTOM,
	DC,
	DIC,
	J,
	PACHINKO,
	PEACE,
	X
}

const TILE_LIST = {
	TILE_TYPES.ASTERISK: preload('res://resources/tiles/tile_asterisk.tres'),
	TILE_TYPES.BLIND_BOTTOM: preload('res://resources/tiles/tile_blind_bottom.tres'),
	TILE_TYPES.DC: preload('res://resources/tiles/tile_dc.tres'),
	TILE_TYPES.DIC: preload('res://resources/tiles/tile_dic.tres'),
	TILE_TYPES.J: preload('res://resources/tiles/tile_j.tres'),
	TILE_TYPES.PACHINKO: preload('res://resources/tiles/tile_pachinko.tres'),
	TILE_TYPES.PEACE: preload('res://resources/tiles/tile_peace.tres'),
	TILE_TYPES.X: preload('res://resources/tiles/tile_x.tres'),
}

func buildDeck(size: int) -> Array[TileResource]:
	var deck: Array[TileResource] = []
	for i in range(size):
		var j = randi_range(0, TILE_LIST.size() - 1)
		var tile = TILE_LIST.values()[j]
		deck.append(tile)
	
	return deck

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
	TILE_TYPES.ASTERISK: 'res://scenes/tiles/tile_asterisk.tscn',
	TILE_TYPES.BLIND_BOTTOM: 'res://scenes/tiles/tile_blind_bottom.tscn',
	TILE_TYPES.DC: 'res://scenes/tiles/tile_dc.tscn',
	TILE_TYPES.DIC: 'res://scenes/tiles/tile_dic.tscn',
	TILE_TYPES.J: 'res://scenes/tiles/tile_j.tscn',
	TILE_TYPES.PACHINKO: 'res://scenes/tiles/tile_pachinko.tscn',
	TILE_TYPES.PEACE: 'res://scenes/tiles/tile_peace.tscn',
	TILE_TYPES.X: 'res://scenes/tiles/tile_x.tscn',
}

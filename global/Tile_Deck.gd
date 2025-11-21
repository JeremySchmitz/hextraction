extends Node

enum TILE_TYPES  {
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
	TILE_TYPES.ASTERISK: preload('res://scenes/tiles/tile_asterisk.tscn'),
	TILE_TYPES.BLIND_BOTTOM: preload('res://scenes/tiles/tile_blind_bottom.tscn'),
	TILE_TYPES.DC: preload('res://scenes/tiles/tile_dc.tscn'),
	TILE_TYPES.DIC: preload('res://scenes/tiles/tile_dic.tscn'),
	TILE_TYPES.J: preload('res://scenes/tiles/tile_j.tscn'),
	TILE_TYPES.PACHINKO: preload('res://scenes/tiles/tile_pachinko.tscn'),
	TILE_TYPES.PEACE: preload('res://scenes/tiles/tile_peace.tscn'),
	TILE_TYPES.X: preload('res://scenes/tiles/tile_x.tscn'),
	
}

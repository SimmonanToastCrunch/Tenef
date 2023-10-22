
# a class which decides how a structure should affect the tilemap its placed on
class TileMask extends Node:
	# exents of this rectangle
	var boundary_left : int
	var boundary_right : int
	var boundary_up : int
	var boundary_down : int
	
	var position : Vector2
	
	# what type of tile this should be
	# 0 = impassable
	# 1 = passable
	# 2 = topmost
	var tile_type : int
	
	
	func _init(p_position = Vector2.ZERO, left = 0, right = 0, up = 0, down = 0, type = 1) -> void:
		position = p_position
		boundary_left = left
		boundary_right = right
		boundary_up = up
		boundary_down = down
		tile_type = type
	
	
	func _change_tilemap(tilemap : TileMap) -> void:
		var height : int = boundary_up + boundary_down
		var width : int = boundary_left + boundary_right
		
	


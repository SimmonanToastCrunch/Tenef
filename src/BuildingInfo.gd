extends Node2D

const cell_size = Vector2(48, 48)

# a grid storing references for each tile in the world
# values of zero/null/no-entry means no building
var grid = {
	
}


# array storing all building instances
var structures : Array = [
	
]


var tilemap : TileMap


# ~~~ NOTE ~~~ #
# AI and building coordinates should be passed in as grid coordinates, not world coordinates


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	_update()


func _reset() -> void:
	grid.clear()


func _update() -> void:
	if get_tree().has_group("tilemap_topmost"):
		tilemap = get_tree().get_nodes_in_group("tilemap_topmost")[0]


# returns true if the position is not filled
func _check_position(p_position : Vector2) -> bool:
	return !grid.has(p_position)


# adds a building at the desired x and y position
func _add_building(building : Node2D, p_position : Vector2) -> bool:
	if !grid.has(p_position):
		grid[p_position] = building
		AI._set_navigation_tile(p_position.x, p_position.y, -1)
		return true
	return false


func _remove_building(p_position : Vector2) -> void:
	AI._set_navigation_tile(p_position.x, p_position.y, 0)
	grid.erase(p_position)


# pass in global coordinates/mouse position to return a cell position (for example, what tile the mouse position is over)
func _to_grid(global_position : Vector2) -> Vector2:
	return tilemap.world_to_map(global_position)


func _to_world(grid_position : Vector2) -> Vector2:
	return grid_position * cell_size


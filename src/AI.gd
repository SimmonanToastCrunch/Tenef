extends Node2D

var level_navigation : Navigation2D = null
var tilemap_navigation : TileMap = null


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	_update()


func _update() -> void:
	if get_tree().has_group("level_navigation"):
		level_navigation = get_tree().get_nodes_in_group("level_navigation")[0]
	if get_tree().has_group("tilemap_navigation"):
		tilemap_navigation = get_tree().get_nodes_in_group("tilemap_navigation")[0]

func _set_navigation_tile(x : int, y : int, value : int) -> void:
	tilemap_navigation.set_cell(x, y, value)


func _bake_navigation() -> void:
	tilemap_navigation.update_dirty_quandrants()

extends Node2D


var generator : Generator = null
var clustergroups : Array = []
var level : Node2D = null


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	if get_tree().has_group("generator"):
		generator = get_tree().get_nodes_in_group("generator")[0]
	else:
		print("Cluster cannot work if there is no generator data!")
		return
	if get_tree().has_group("level"):
		level = get_tree().get_nodes_in_group("level")[0]
	else:
		print("Cluster cannot work if there is no level!")
		return
	
	clustergroups = generator.clustergroups
	_spawn_enemies()


func _spawn_enemies() -> void:
	var index = randi() % clustergroups.size()
	var instance = clustergroups[index].instance()
	instance.position = position
	level.call_deferred("add_child", instance)

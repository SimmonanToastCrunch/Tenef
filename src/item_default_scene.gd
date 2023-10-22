extends Node

var position = Vector2.ZERO

func _on_Node_tree_entered():
	queue_free()

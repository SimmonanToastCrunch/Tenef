class_name Structure
extends Node2D

# scene to be instanced
var scene : PackedScene
# likelihood of this structure appearing. Higher weight = greater chance
var weight : int
# if a tile is occupied buildings cannot be placed on it. for example, do not set blank structures to occupied
# this will also be used for navigation
var occupied : bool
# the total weight of every structure before this one in its array
# used for weighted die rolls
var weight_under : int
# internal ID this structure stores
var id : int


func _init(scene_path, p_id, p_weight = 1, p_occupied = true):
	scene = load(scene_path)
	weight = p_weight
	occupied = p_occupied
	id = p_id

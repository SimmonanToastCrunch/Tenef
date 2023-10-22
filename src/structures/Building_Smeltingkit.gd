extends StaticBody2D

const Recipe = preload("res://src/Recipe.gd").Recipe
const use_distance : int = 100

var recipes = [
	Recipe.new("Iron Lump", 1, {
		"Iron Ore": 3,
	}),
	Recipe.new("Silver Lump", 1, {
		"Silver Ore": 3,
	})
]


func _ready() -> void:
	BuildingInfo._add_building(self, BuildingInfo._to_grid(global_position))


func _on_interact():
	if position.distance_to(PlayerInventory.player.position) <= use_distance:
		PlayerInventory.player.get_node("InventoryUI")._set_recipes(recipes)
		PlayerInventory.player.get_node("InventoryUI")._toggle_inventory()

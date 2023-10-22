extends StaticBody2D

var Recipe = load("res://src/Recipe.gd").Recipe


func _ready() -> void:
	BuildingInfo._add_building(self, BuildingInfo._to_grid(global_position))

var recipes = [
	Recipe.new("Wood Hat", 1, {
		"Wood": 3,
		"Lumber": 1,
	}),
	Recipe.new("Wood Cuirass", 1, {
		"Wood": 6,
		"Lumber": 2,
	}),
	Recipe.new("Sandals", 1, {
		"Wood": 2,
		"Lumber": 1,
	}),
	Recipe.new("Polished Adze", 1, {
		"Stone Adze": 1,
		"Lumber": 3,
		"Stone": 2
	}),
	Recipe.new("Polished Pick", 1, {
		"Stone Pick": 1,
		"Lumber": 2,
		"Stone": 3,
	}),
	Recipe.new("Bone Sword", 1, {
		"Bone Scraps": 4,
		"Lumber": 1,
	}),
	Recipe.new("Bone Pick", 1, {
		"Bone Scraps": 5,
		"Lumber": 2,
	}),
	Recipe.new("Smelting Kit", 1, {
		"Stone": 15,
		"Lumber": 1,
		"Iron Ore": 3,
	})
]

# how many pixels away the player can be before the bench is no longer reachable
var use_distance : int = 100

# player has attempted to open the workbench
func _on_pressed():
	if position.distance_to(PlayerInventory.player.position) <= use_distance:
		PlayerInventory.player.get_node("InventoryUI")._set_recipes(recipes)
		PlayerInventory.player.get_node("InventoryUI")._toggle_inventory()

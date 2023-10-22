extends Control

# initial change in position for all recipe options
const crafting_box_offset = Vector2(228, 32)
# y distance between each box
const padding = 24
# height of each option
const option_height = 90

const Recipe = preload("res://src/Recipe.gd").Recipe

var crafting_box : PackedScene = preload("res://scenes/ui/CraftingOption.tscn")


var current_recipe : Recipe = null
var player : Node = null


var recipes = [
]


var item_hints = [
	
]


func _ready() -> void:
	get_tree().call_group("itemhints", "connect", "add_to_array", self, "_add_hint_to_array")
	get_tree().call_group("itemhints", "_add_self_to_array")

func _set_recipes(array : Array) -> void:
	# this may cause an issue later.
	# may cause all recipes in this array to be deleted, not just the references in the array
	recipes.clear()
	recipes.append_array(array)
	_set_scroll_maximum((option_height * recipes.size()) + padding)
	_create_recipe_boxes()


func _set_scroll_maximum(value : int) -> void:
	$RecipeBrowser/VScrollBar2.max_value = value


func _create_recipe_boxes() -> void:
	get_tree().call_group("craftingoption", "queue_free")
	for i in recipes.size():
		# meta related
		var instance = crafting_box.instance()
		instance.rect_position.x += crafting_box_offset.x
		instance.def_y = (option_height * i) + padding
		instance.rect_position.y += (option_height * i) + padding
		
		# recipe related
		instance.recipe = recipes[i]
		instance.text = recipes[i].result + " x"+ str(recipes[i].result_amount)
		instance.icon = ItemLookup._get_as_item(recipes[i].result).item_texture
		
		
		# node related
		instance.connect("option_selected", self, "_on_recipe_clicked")
		$RecipeBrowser.add_child(instance)
		_set_scroll_maximum(recipes.size() * 64)


func _on_recipe_clicked(recipe) -> void:
	current_recipe = recipe
	_set_hints(recipe)


func _clear_hints() -> void:
	pass
	$ResultHint._clear_item()
	for i in item_hints.size():
		item_hints[i]._clear_item()


# change the items stored in each hint box to the correct item
func _set_hints(recipe : Recipe) -> void:
	_clear_hints()
	var item = ItemLookup._get_as_item(recipe.result)
	item.amount = recipe.result_amount
	$ResultHint._set_item(item)
	var keys : Array = recipe.items_needed[0].keys()
	for i in recipe.items_needed[0].size():
		var cost_item = ItemLookup._get_as_item(keys[i])
		cost_item.amount = recipe.items_needed[0][keys[i]]
		item_hints[i]._set_item(cost_item)


func _add_hint_to_array(node : Node) -> void:
	item_hints.push_back(node)


func _on_craft_pressed() -> void:
	if current_recipe != null:
		if current_recipe._can_craft(PlayerInventory):
			current_recipe._craft(PlayerInventory)


func _on_scroll():
	get_tree().call_group("craftingoption", "_on_scroll", $RecipeBrowser/VScrollBar2.value)

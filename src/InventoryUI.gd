extends CanvasLayer


var is_visible : bool = false
export(PackedScene) var itembox_scene


export(bool) var debug = true


# true if an item has been clicked and is currently following the mouse cursor
var holding_item : bool = false


# how far each box should be from the top left corner of the background
var box_offset : Vector2 = Vector2.ZERO
# how far each box should be from each other
var padding : Vector2 = Vector2.ZERO


# how many itemboxes go into a row
var rowx : int = 5

func _process(_delta):
	if Input.is_action_just_pressed("inventory_open"):
		$RecipeBrowser._set_recipes(ItemLookup.recipe_registry)
		_toggle_inventory()


func _toggle_inventory() -> void:
	if is_visible:
		_hide()
		get_tree().call_group("itemboxes", "_delete_info")
	else:
		_show()

func _ready():
	box_offset.x = 128
	box_offset.y = 128
	_hide()
	_create_item_boxes()

func _show() -> void:
	is_visible = true
	get_tree().call_group("itemboxes", "_show_box")
	$RecipeBrowser.show()
	$ItemboxDelete.show()
	$Background.show()
	$Items.show()
	$ButtonSettings.show()
	$Headbox.show()
	$Chestbox.show()
	$Feetbox.show()
	$Gold.position = Vector2(96, 1050)

func _hide() -> void:
	is_visible = false
	get_tree().call_group("itemboxes", "_hide_box")
	get_tree().call_group("iteminfo", "_delete")
	$RecipeBrowser.hide()
	$ItemboxDelete.hide()
	$Background.hide()
	$Items.hide()
	$ButtonSettings.hide()
	$Headbox.hide()
	$Chestbox.hide()
	$Feetbox.hide()
	$Gold.position = Vector2(32, 160)

# creates all the item boxes needed and childs them to this node
func _create_item_boxes() -> void:
	get_tree().call_group("itemboxes", "queue_free")
	var rowy : int = 0
	for i in PlayerInventory.storage.size():
		#warning-ignore:narrowing_conversion
		rowy = floor(i / rowx)
		var instance = itembox_scene.instance()
		instance.rowx = rowx
		instance.offset = box_offset
		instance.position.x = (i * 100 + box_offset.x) - rowy * (rowx * 100) # strange looking code here, simply keeps box's x axis correct
		instance.position.y = rowy * 100 + box_offset.y
		instance.index = i
		instance.connect("itembox_clicked", self, "_on_itembox_clicked")
		add_child(instance)
	_hide()
	_update_inventory()
	

# changes the sprites and items stored in each inventory box
func _update_inventory() -> void:
	get_tree().call_group("itemboxes", "_update_self")
	get_tree().call_group("equipboxes", "_update_self")
	#mayhaps be causing issues, seems ghost items don't appear after moving the item in your inventory
	get_parent()._spawn_ghost_item(PlayerInventory.storage[PlayerInventory.selection_index])


func _set_recipes(recipes : Array) -> void:
	$RecipeBrowser._set_recipes(recipes)


# changes how many boxes are in the inventory screen
func _update_inventory_size() -> void:
	get_tree().call_group("itemboxes", "queue_free")
	_create_item_boxes()


# code that's executed when any item box is clicked
func _on_itembox_clicked(index : int, box : Node) -> void:
	if holding_item:
		# is the item we're clicking on the same as the one that's being held/following the cursor? if so, add item to the stack
		if PlayerInventory.storage[index].item_name == get_node("HeldItem").stored_item.item_name:
			var remainder = PlayerInventory.storage[index]._add_stack(get_node("HeldItem").stored_item.amount)
			# do we need to delete the held item or can we simply change amount?
			if  remainder > 0:
				get_node("HeldItem").stored_item.amount = remainder
			else:
				get_node("HeldItem").queue_free()
				holding_item = false
		# is the box we're trying to place the item in a blank space? if so, simply put item there
		elif PlayerInventory.storage[index].item_name == "blank_item":
			PlayerInventory.storage[index]._set_item(get_node("HeldItem").stored_item)
			box._create_info()
			
			get_node("HeldItem").queue_free()
			holding_item = false
		# is the item we're clicking NOT the same as the one that's being held? if so, swap item
		else:
			# an "offhand" item with which we can store the data of one item, overwrite that item, then replace the original we swapped it with
			var offhand : Item = Item.new()
			# set this offhand to value that's about to be replaced
			offhand._set_item(PlayerInventory.storage[index])
			# overwrite the box that's been clicked with item we're already holding
			PlayerInventory.storage[index]._set_item(get_node("HeldItem").stored_item)
			# swap currently held item with the item that was originally in the box
			get_node("HeldItem").stored_item._set_item(offhand)
			get_node("HeldItem")._update_cursor()
		
		
	else:
		if PlayerInventory.storage[index].item_name == "blank_item":
			return
		var scene : PackedScene = load("res://scenes/ui/HeldItem.tscn")
		var instance = scene.instance()
		var item : Item = PlayerInventory.storage[index]
		instance.stored_item = Item.new() #DING DING DING
		instance.stored_item._set_item(item)
		instance._update_cursor()
		add_child(instance)
		holding_item = true
		PlayerInventory.storage[index]._clear_item()
	_update_inventory()


func _on_equipbox_clicked(type : int) -> void:
	if holding_item:
		if get_node("HeldItem").stored_item.armor_type == type + 1:
			# clicked equip box is empty
			if PlayerInventory.equipment[type].item_name == "blank_item":
				PlayerInventory.equipment[type]._set_item(get_node("HeldItem").stored_item)
				get_node("HeldItem").queue_free()
				holding_item = false
	else:
		# pick up item
		if PlayerInventory.equipment[type].item_name != "blank_item":
			var scene : PackedScene = load("res://scenes/ui/HeldItem.tscn")
			var instance = scene.instance()
			var item : Item = PlayerInventory.equipment[type]
			instance.stored_item = Item.new()
			instance.stored_item._set_item(item)
			instance._update_cursor()
			add_child(instance)
			holding_item = true
			PlayerInventory.equipment[type]._clear_item()
	_update_inventory()
	PlayerInventory._print_defense()


func _on_delete_clicked():
	if holding_item:
		var deleted_item : Item = get_node("HeldItem").stored_item
		PlayerInventory.storage_history[deleted_item.item_name] -= deleted_item.amount
		get_node("HeldItem").queue_free()
		holding_item = false


func _on_settings_pressed() -> void:
	$SettingsMenuUI.show()


func _on_settings_toggled() -> void:
	if $SettingsMenuUI.visible:
		get_tree().set_group("itemboxes", "pickable", false)
	else:
		get_tree().set_group("itemboxes", "pickable", true)

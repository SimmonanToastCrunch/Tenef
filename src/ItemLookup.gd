extends Node

const folder_weapon_texture = "res://assets/art/weapons/"
const folder_weapon_scene = "res://scenes/weapons/"

const folder_item_texture = "res://assets/art/items/"

const default_scene = "res://scenes/weapons/item_default_scene.tscn"


var Recipe = load("res://src/Recipe.gd").Recipe


# grey
const quality_junk = Color(0.6, 0.6, 0.6)
# white
const quality_common = Color(1.0, 1.0, 1.0)
# skyish blue
const quality_uncommon = Color(0.2, 0.65, 0.8)
# nice violet
const quality_rare = Color(0.70, 0.1, 0.75)
# orange
const quality_legendary = Color(0.9, 0.47, 0.094)
# red
const quality_cursed = Color(0.8, 0.1, 0.1)


func _ready():
	randomize()


# a dictionary holding data on every item in the game
# item registries go as follows "item_name": { "max_count": x, "texture": <path_to_texture>, [...] }
var registry = {
	
	"blank_item": {
		"max_count": 1,
		"texture": folder_item_texture + "item_blank.png",
		"on_use": default_scene,
		"description": "debug_item\nblank_description",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		},
	"Wood": {
		"max_count": 99,
		"texture": folder_item_texture + "wood.png",
		"on_use": default_scene,
		"description": "Material",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Stone": {
		"max_count": 99,
		"texture": folder_item_texture + "stone.png",
		"on_use": default_scene,
		"description": "Material",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Lumber": {
		"max_count": 99,
		"texture": folder_item_texture + "lumber.png",
		"on_use": default_scene,
		"description": "Material\nLonger, more refined pieces of wood",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Iron Ore": {
		"max_count": 99,
		"texture": folder_item_texture + "iron_ore.png",
		"on_use": default_scene,
		"description": "Material\nCan be processed into iron using a smelting kit",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Iron Lump": {
		"max_count": 99,
		"texture": folder_item_texture + "iron_lump.png",
		"on_use": default_scene,
		"description": "Material\nCan be refined into tools and weaponry",
		"quality": quality_uncommon,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Sand Sword": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_sand_sword.png",
		"on_use": folder_weapon_scene + "weapon_sand_sword.tscn",
		"description": "8 Damage\nModerate Speed\n3 Stamina\n\nFires balls of sand which deal minor damage and slows targets",
		"quality": quality_cursed,
		"ghost_texture": null,
		"cursed": true,
		"armor": 0,
		"defense": 0,
	},
	"Stone Spear": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_stone_spear.png",
		"on_use": folder_weapon_scene + "weapon_stone_spear.tscn",
		"description": "4 Damage\n2 Stamina\nModerate Speed",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Stone Adze": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_stone_adze.png",
		"on_use": folder_weapon_scene + "weapon_stone_adze.tscn",
		"description": "2 Damage\n2 Stamina\nSlow Speed\n\nCan harvest lumber",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Stone Pick": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_stone_pick.png",
		"on_use": folder_weapon_scene + "weapon_stone_pick.tscn",
		"description": "3 Damage\n4 Stamina\nSlow Speed\n\nCan harvest stone",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Primitive Club" : {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_club.png",
		"on_use": folder_weapon_scene + "weapon_club.tscn",
		"description": "4-6 Damage\n3 Stamina\nSlow Speed",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Polished Adze": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_polish_adze.png",
		"on_use": folder_weapon_scene + "weapon_polished_adze.tscn",
		"description": "3-4 Damage\n3 Stamina\nModerate Speed\nCan harvest roots",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Polished Pick": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_polished_pick.png",
		"quality": quality_common,
		"description": "3-4 Damage\n3 Stamina\nSlow Speed\nCan harvest stone and terrametals"
	},
	"Workbench": {
		"max_count": 99,
		"texture": "res://assets/art/structures/building_workbench.png",
		"on_use": "res://scenes/items/Workbench_Scene.tscn",
		"description" : "Unlocks new recipes",
		"quality": quality_common,
		"ghost_texture": "res://assets/art/structures/building_workbench.png",
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Smelting Kit": {
		"max_count": 99,
		"texture": folder_item_texture + "smeltingkit.png",
		"on_use": "res://scenes/items/Smeltingkit_Scene.tscn",
		"description": "For all your smithing needs!",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Backpack Cookie": {
		"max_count": 99,
		"texture": "res://assets/art/items/cookie.png",
		"on_use": "res://scenes/items/Cookie.tscn",
		"description": "Increases your backpack size\nChocolate chips, yum!",
		"quality": quality_legendary,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Silver Ore": {
		"max_count": 99,
		"texture": folder_item_texture + "silver_ore.png",
		"on_use": default_scene,
		"description": "Material\nCan be processed into silver using a smelting kit",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Silver Lump": {
		"max_count": 99,
		"texture": folder_item_texture + "silver_lump.png",
		"on_use": default_scene,
		"description": "Material\nCan be refined into tools and weaponry",
		"quality": quality_uncommon,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Small Health Potion": {
		"max_count": 99,
		"texture": folder_item_texture + "health_pot.png",
		"on_use": default_scene,
		"description": "Restores 20 HP\nShort consume time",
		"quality": quality_cursed,
		"ghost_texture": null,
		"cursed": true,
		"armor": 0,
		"defense": 0,
	},
	"Wood Hat": {
		"max_count": 1,
		"texture": folder_item_texture + "wood_hat.png",
		"on_use": default_scene,
		"description": "2 Defense",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 1,
		"defense": 2,
	},
	"Wood Cuirass": {
		"max_count": 1,
		"texture": folder_item_texture + "wood_chest.png",
		"on_use": default_scene,
		"description": "3 Defense",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 2,
		"defense": 3,
	},
	"Sandals": {
		"max_count": 1,
		"texture": folder_item_texture + "wood_shoes.png",
		"on_use": default_scene,
		"description": "1 Defense",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 3,
		"defense": 1,
	},
	"\"Happy Thoughts\" Pin": {
		"max_count": 1,
		"texture": folder_item_texture + "happythoughtspin.png",
		"on_use": default_scene,
		"description": "+5% and +15 max HP",
		"quality": quality_cursed,
		"ghost_texture": null,
		"cursed": true,
		"armor": 2
	},
	"Bone Scraps": {
		"max_count": 99,
		"texture" : folder_item_texture + "bonescraps.png",
		"description": "Material",
		"quality": quality_junk
	},
	"Bone Sword": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_bone_sword.png",
		"description": "5-6 Damage\n3 Stamina\nModerate Speed",
		"quality": quality_common,
		"on_use": folder_weapon_scene + "weapon_bone_sword.tscn"
	},
	"Bone Pick": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_bone_pick.png",
		"description": "4 Damage\n4 Stamina\nSlow speed",
		"quality": quality_common,
	},
	# todo: bone axe
	"Iron Hatchet": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_iron_hatchet.png",
		"description": "4-5 Damage\n3 Stamina\nModerate Speed\nCan harvest root pillars",
		"quality": quality_uncommon,
	}
}

var recipe_registry = [
	Recipe.new("Stone Adze", 1, {
		"Wood": 2,
		"Stone": 4
	}),
	Recipe.new("Stone Pick", 1, {
		"Wood": 5,
		"Stone": 2,
	}),
	Recipe.new("Stone Spear", 1, {
		"Wood": 3,
		"Stone": 2,
	}),
	Recipe.new("Primitive Club", 1, {
		"Wood": 4
	}),
	Recipe.new("Workbench", 1, {
		"Wood": 1,
	}),
	Recipe.new("Backpack Cookie", 1, {
		"Wood": 1,
	}),
	
]

# converts a registry to a usable item. Count will remain -1
func _get_as_item(item_name : String) -> Item:
	var item = registry.get(item_name)
	if item == null:
		return Item.new()
	else:
		
		var maxcount = 99
		var texture = folder_item_texture + "item_blank.png"
		var onuse = default_scene
		var description = ""
		var quality = quality_junk
		var ghosttexture = null
		var cursed = false
		var armor = 0
		var defense = 0
		
		if item.has("max_count"):
			maxcount = item.max_count
		if item.has("texture"):
			texture = item.texture
		if item.has("description"):
			description = item.description
		if item.has("on_use"):
			onuse = item.on_use
		if item.has("quality"):
			quality = item.quality
		if item.has("ghost_texture"):
			ghosttexture = item.ghost_texture
		if item.has("cursed"):
			cursed = item.cursed
		if item.has("armor"):
			armor = item.armor
		if item.has("defense"):
			defense = item.defense
		
		
		# correct item
		# check if this item should have a ghost texture
		if ghosttexture != null:
			return Item.new(item_name, load(texture), description, quality, -1, maxcount, load(onuse), load(ghosttexture), cursed, armor, defense)
		return Item.new(item_name, load(texture), description, quality, -1, maxcount, load(onuse), null, cursed, armor, defense)
		
		

extends YSort


export(bool) var buildable = true


func _ready() -> void:
	var file = File.new()
	if file.file_exists("res://saves/" + Game.world_name + ".json"):
		# load in save
		$WorldGenerator.generator = Generator.new()
		$WorldGenerator._load()
		
	else:
		$WorldGenerator.generator = Generator.new()
		$WorldGenerator._init_generator()
		$WorldGenerator._generate_world(true, false)
		# generation finished
		Game._set_player_position()

# Experimental code that might be visited later. Exists to save data to world after exitting game
## we need to save all progress thus far
#func _exit_tree() -> void:
#	# stores indices of all known changes to structures
#	var changes : Array = []
#	# check through all known structures to see what changed
#	for i in range(BuildingInfo.structures.size()):
#		if BuildingInfo._check_position(Vector2(BuildingInfo.structures[i][0], BuildingInfo.structures[i][1])):
#			changes.push_back(i)
#			print("D'oh!")
#
#
#	# work backwards thru array removing stuff that doesn't exist anymore
#	for i in range(changes.size()):
#		BuildingInfo.structures.remove(changes.size() - i - 1)
#
#
#	# load in save file
#	var save = File.new()
#	save.open("res://saves/" + Game.world_name + ".json", File.READ)
#	var save_data = SaveParser._to_dict(save.get_as_text())
#	save.close()
#
#
#	var tiles = save_data.world.tiles
#	# update tile data with correct structure data
#	print(BuildingInfo.structures.size())
#	for i in range(BuildingInfo.structures.size() - 1):
#		var object = tiles[i]
#		if object[0] == BuildingInfo.structures[i][0] and object[1] == BuildingInfo.structures[i][1]:
#			tiles[i][3] = BuildingInfo.structures[i][2]
#
#
#	# save to file
#	Game._save(save_data)
#

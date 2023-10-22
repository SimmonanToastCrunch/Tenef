extends YSort


export(bool) var buildable = false


func _ready() -> void:
	$WorldGenerator.generator = SubsurfaceGenerator.new()
	$WorldGenerator._init_generator()
	yield(get_tree(), "idle_frame")
	$WorldGenerator._generate_world()
	
	# generation finished
	Game._set_player_position()

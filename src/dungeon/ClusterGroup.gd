# a data class for holding info about what kinds of monsters should spawn and how
# represents a single cluster object
class ClusterGroup:
	
	var monsters : Array = [
		
	]
	
	
	func _init(pmonsters : Array) -> void:
		monsters = pmonsters
	
	
	

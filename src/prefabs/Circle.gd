class Circle:
	
	var center : Vector2
	var radius : int
	
	
	func _init(p_center : Vector2, p_radius : int) -> void:
		center = p_center
		radius = p_radius
	
	
	# calculates the edges of and applies this circle to a tilemap (in pool int arr format)
	func _apply_circle(tiles : PoolVector2Array, tile_data : PoolRealArray) -> PoolRealArray:
		var arr : PoolRealArray = tile_data
		arr.resize(tiles.size())
		
		for i in range(tiles.size()):
			var distance = center.distance_to(tiles[i])
			
			if distance <= radius:
				arr[i] = radius - distance
		
		return arr
	

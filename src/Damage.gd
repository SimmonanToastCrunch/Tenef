class Damage:
	var damage_min : int
	var damage_max : int
	
	const damage_cap = 199
	
	func _init(p_min : int, p_max : int):
		damage_min = p_min
		damage_max = p_max
	
	func _damage() -> int:
		var value = round(rand_range(damage_min, damage_max))
		return value

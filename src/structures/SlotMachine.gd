extends StaticBody2D


#class template for potential results for slot machine
class ResultPair:
	
	var result : int
	var weight : int
	
	func _init(presult : int, pweight : int) -> void:
		if pweight <= 0:
			print("Weight can't be less than 1, retard")
			return
		result = presult
		weight = pweight

func _within(value : int, pmin : int, pmax : int) -> bool:
	return value >= pmin and value <= pmax

export(int) var cost = 25


var pool : Array = [
	ResultPair.new(-25, 1),
	ResultPair.new(-10, 2),
	ResultPair.new(0, 10),
	ResultPair.new(5, 8),
	ResultPair.new(30, 3),
	ResultPair.new(50, 2),
	ResultPair.new(100, 1)
]


func _ready() -> void:
	$Machine/Coin/X/Amount.text = str(cost)


func _on_player_contact(area) -> void:
	area.get_parent()._queue_interactable_object(self)
	$Machine/HUD.show()


func _on_player_uncontact(area) -> void:
	area.get_parent()._dequeue_interactable_object(self)
	$Machine/HUD.hide()


func _interact(player : Node2D) -> void:
	if PlayerInventory.gold >= 25:
		PlayerInventory._remove_gold(25)
		_random_effect()


func _random_effect() -> void:
	# reusing similar approach for structure picking (I think?)
	# add up total weight then roll random number
	var totalweight : int = 0
	for result in pool:
		totalweight += result.weight
	var weightthus : int = 0
	var pooladjustweight : Array = []
	for result in pool:
		pooladjustweight.push_back(ResultPair.new(result.result, result.weight + weightthus))
		weightthus += result.weight
	
	var index = randi() % weightthus

	


func _spawn_gold(amount : int = 1) -> void:
	for i in range(amount):
		var instance = load("res://scenes/items/DroppedGold.tscn").instance()
		instance.position = position
		get_parent().add_child(instance)

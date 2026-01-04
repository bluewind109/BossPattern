class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int = 0


func add_item(item, weight: int):
	items.append({"item": item, "weight": weight})
	weight_sum += weight


func remove_item(item_to_remove):
	items = items.filter(func(item): 
		return item["item"] != item_to_remove
	)
	weight_sum = 0
	for item in items: 
		weight_sum += item["weight"]


func pick_item(exclude: Array = []):
	var filtered_items: Array[Dictionary] = items.duplicate()
	var filtered_weight_sum = weight_sum
	if (exclude.size() > 0):
		filtered_items = []
		for item in items:
			if (item["item"] in exclude): # skip exclude item
				continue
			filtered_items.append(item)
			filtered_weight_sum += item["weight"]

	var chosen_weight = randi_range(1, filtered_weight_sum)
	var iteration_sum = 0
	for item in filtered_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]

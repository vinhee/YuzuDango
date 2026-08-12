extends Resource

class_name Inventory

signal updated
@export var slots: Array[InventorySlot]

func insert(item: ItemData):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	updated.emit()

func get_item_count(item: ItemData) -> int:
	var total := 0
	for slot in slots:
		if slot.item == item:
			total += slot.amount
	return total

func remove_item(item: ItemData, amount: int) -> bool:
	if get_item_count(item) < amount:
		return false
	var remaining := amount
	for slot in slots:
		if slot.item == item and remaining > 0:
			var take = min(slot.amount, remaining)
			slot.amount -= take
			remaining -= take
			if slot.amount <= 0:
				slot.item = null
				slot.amount = 0
	updated.emit()
	return true

func add_item(item: ItemData, amount: int) -> void:
	for i in amount:
		insert(item)

func get_all_items() -> Array:
	var valid_items = []
	for slot in slots:
		if slot != null and slot.item != null and slot.amount > 0:
			valid_items.append(slot)
	return valid_items

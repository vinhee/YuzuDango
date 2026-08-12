extends Node

signal money_changed(new_amount: int)

var amount: int = 0

func add(value: int) -> void:
	amount += value
	money_changed.emit(amount)

func spend(value: int) -> bool:
	if amount >= value:
		amount -= value
		return true
	return false

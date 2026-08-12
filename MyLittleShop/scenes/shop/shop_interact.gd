extends Area2D

class_name Shop

@export var shop_name: String = "Selling Board"

func interact(player: Player) -> void:
	ShopUI.open(player, shop_name)

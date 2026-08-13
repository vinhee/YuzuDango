extends Area2D

class_name Shop

@export var shop_name: String = "Shop"
@export var shop_stock: Array[ItemData] = []

func interact(player: Player) -> void:
	ShopUI.open(shop_stock, player, shop_name)

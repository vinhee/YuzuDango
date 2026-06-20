class_name collectableComp
extends Area2D

@export var itemRes: InventoryItem
@export var collectable_name: String
@export var amount: int = 1

var available := true

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		try_pickup(body)

func try_pickup(player: Player):
	if not available:
		return
		
	if itemRes == null:
		print("WARNING: Dropped item is missing its InventoryItem resource!")
		get_parent().queue_free()
		return

	if player.inventory:
		pickup(player)

func pickup(player: Player):
	available = false
	print("Picked up ", amount, " ", itemRes.name if itemRes else "unknown item")

	for i in range(amount):
		player.inventory.insert(itemRes)
		
	get_parent().queue_free()

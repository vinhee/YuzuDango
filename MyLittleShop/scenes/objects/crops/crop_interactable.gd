class_name CropInteractable
extends Interactable
@export var crop: Crop

func interact(player: Player) -> void:
	if not crop.is_harvestable():
		return

	var product: ItemData = crop.data.harvest_product_item

	if crop.data.regrows_after_harvest:
		crop.reset_after_harvest()
	else:
		FarmManager.crops.erase(crop.cell)
		crop.queue_free()

	# vin add the harvesting part here (adding to inventory)
	# player.inventory.insert(product)
	
	# js so ik it works, not actually in inventory yet
	print("Harvested: ", product.item_name if product else "unknown item")

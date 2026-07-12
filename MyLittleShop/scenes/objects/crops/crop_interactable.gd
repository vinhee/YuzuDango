class_name CropInteractable
extends Interactable
var crop: Crop

func interact(player: Player) -> void:
	try_harvest(player)

func try_harvest(player: Player) -> void:
	if crop == null:
		return
	if not crop.is_harvestable():
		return
	#var product: InventoryItem = crop.try_harvest()
	#if product == null:
		#return
	# VIN HELP DO PICKUP FOR HARVESTABLE CROP, i commented but shld be correct logic
	# something like:
	# player.inventory.insert(product) same as Forageable.pickup()?
	#if player.inventory:
		#player.inventory.insert(product)
	#print("Harvested: ", product)
	#if not crop.crop_data.regrows_after_harvest:
		#FarmManager.crops.erase(crop.cell)
		#crop.queue_free()

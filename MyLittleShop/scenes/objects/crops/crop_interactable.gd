class_name CropInteractable
extends Interactable
var crop: Crop

func interact(player: Player) -> void:
	if crop:
		crop.interact(player)

# reused for each diff type of workstation
extends Interactable
class_name Workstation

@export var available_recipes: Array[Recipe] = []

func interact(player: Player) -> void:
	CraftingUI.open(available_recipes, player.inventory)

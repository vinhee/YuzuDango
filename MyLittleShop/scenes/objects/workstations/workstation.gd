extends Interactable
class_name Workstation

@export var station_name: String
@export var available_recipes: Array[Recipe] = []

func interact(player: Player) -> void:
	CraftingUI.open(available_recipes, player.inventory, station_name)

extends Control
# attached to craftingui scene
# visible = false at the start
# process mode = always bc we pause the game when crafting
# when time is paused must still be able to press stuff

@onready var recipe_list: ItemList = $Panel/RecipeList
@onready var ingredient_list: VBoxContainer = $Panel/IngredientList
@onready var quantity_spinbox: SpinBox = $Panel/QuantitySpinBox
@onready var craft_button: Button = $Panel/CraftButton

var recipes: Array[Recipe] = []
var inventory: Inventory
var selected_recipe: Recipe

func open(recipes_to_show: Array[Recipe], player_inventory: Inventory) -> void:
	recipes = recipes_to_show
	inventory = player_inventory
	selected_recipe = null
	visible = true
	get_tree().paused = true
	#_populate_recipe_list()

func _on_craft_button_pressed() -> void:
	pass # Replace with function body.

func _on_close_button_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_recipe_list_item_selected(index: int) -> void:
	pass # Replace with function body.

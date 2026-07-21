# attached to craftingui scene
# visible = false at the start
# process mode = always bc we pause the game when crafting
# when time is paused must still be able to press stuff
extends CanvasLayer

@onready var control: Control = $CraftingUi
@onready var title_label: Label = $CraftingUi/Panel/MarginContainer/TitleLabel
@onready var recipe_list: ItemList = $CraftingUi/Panel/MarginContainer/HBoxContainer/RecipeList
@onready var ingredient_list: VBoxContainer = $CraftingUi/Panel/MarginContainer/HBoxContainer/VBoxContainer/IngredientList
@onready var quantity_spinbox: SpinBox = $CraftingUi/Panel/MarginContainer/HBoxContainer/VBoxContainer/QuantitySpinBox
@onready var craft_button: Button = $CraftingUi/Panel/MarginContainer/HBoxContainer/VBoxContainer/CraftButton
var recipes: Array[Recipe] = []
var inventory: Inventory
var selected_recipe: Recipe

func open(recipes_to_show: Array[Recipe], player_inventory: Inventory, station_name: String = "") -> void:
	recipes = recipes_to_show
	inventory = player_inventory
	selected_recipe = null
	title_label.text = station_name
	control.visible = true
	get_tree().paused = true
	_populate_recipe_list()

func _populate_recipe_list() -> void:
	recipe_list.clear()
	for recipe in recipes:
		var idx = recipe_list.add_item(recipe.recipe_name, recipe.output_item.icon)
		recipe_list.set_item_disabled(idx, not _can_craft(recipe, 1))

func _can_craft(recipe: Recipe, amount: int) -> bool:
	for req in recipe.ingredients:
		if inventory.get_item_count(req.item) < req.quantity * amount:
			return false
	return true

func _max_craftable(recipe: Recipe) -> int:
	var max_amount := 999
	for req in recipe.ingredients:
		var have := inventory.get_item_count(req.item)
		max_amount = min(max_amount, have / req.quantity)
	return max(max_amount, 0)

func _on_recipe_list_item_selected(index: int) -> void:
	selected_recipe = recipes[index]
	_update_ingredient_display()

func _update_ingredient_display() -> void:
	for child in ingredient_list.get_children():
		child.queue_free()

	for req in selected_recipe.ingredients:
		var have := inventory.get_item_count(req.item)
		var label := Label.new()
		label.text = "%s: %d / %d" % [req.item.item_name, have, req.quantity]
		label.modulate = Color.RED if have < req.quantity else Color.WHITE
		ingredient_list.add_child(label)

	var max_amount := _max_craftable(selected_recipe)
	quantity_spinbox.min_value = 1 if max_amount > 0 else 0
	quantity_spinbox.max_value = max_amount
	quantity_spinbox.value = min(quantity_spinbox.value, max_amount)
	craft_button.disabled = max_amount <= 0

func _on_craft_button_pressed() -> void:
	var amount := int(quantity_spinbox.value)
	if not _can_craft(selected_recipe, amount):
		return

	for req in selected_recipe.ingredients:
		inventory.remove_item(req.item, req.quantity * amount)
	inventory.add_item(selected_recipe.output_item, selected_recipe.output_quantity * amount)

	_update_ingredient_display()
	_populate_recipe_list()

func _on_close_button_pressed() -> void:
	control.visible = false
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if not control.visible:
		return
	if event.is_action_pressed("ui_cancel"):
		_on_close_button_pressed()
		get_viewport().set_input_as_handled()

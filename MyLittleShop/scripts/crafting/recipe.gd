class_name Recipe
extends Resource

@export var recipe_name: String
@export var output_item: ItemData
@export var output_quantity: int = 1
@export var ingredients: Array[IngredientRequirement] = []

extends Node

signal tool_selected(tool: DataTypes.Tools)

var current_tool: DataTypes.Tools = DataTypes.Tools.None
var selected_seed: ItemData = null  # NEW

func select_tool(tool: DataTypes.Tools) -> void:
	current_tool = tool
	tool_selected.emit(tool)

func select_seed(seed_item: ItemData) -> void:  # NEW
	selected_seed = seed_item
	select_tool(DataTypes.Tools.PlantStrawberry)

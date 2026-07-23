extends Node

signal tool_selected(tool: DataTypes.Tools)

var current_tool: DataTypes.Tools = DataTypes.Tools.None
var selected_seed: ItemData = null 

func select_tool(tool: DataTypes.Tools) -> void:
	current_tool = tool
	tool_selected.emit(tool)

func select_seed(seed_item: ItemData) -> void:
	if seed_item == null:
		push_warning("select_seed called with null seed_item")
		return
	var crop_data: CropData = CropDatabase.get_crop_for_seed(seed_item)
	print("select_seed: seed=", seed_item, " crop_data=", crop_data)
	if crop_data == null:
		push_warning("No CropData for seed: %s" % seed_item.item_id)
		return
	selected_seed = seed_item
	select_tool(crop_data.plant_tool)

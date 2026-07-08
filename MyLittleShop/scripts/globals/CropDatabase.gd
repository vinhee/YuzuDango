# CropDatabase.gd
extends Node
var crop_by_seed_id: Dictionary = {}
var crop_by_tool: Dictionary = {}   # NEW: DataTypes.Tools -> CropData

func _ready() -> void:
	_load_all_crop_data("res://resources/crops/")

func _load_all_crop_data(path: String) -> void:
	var dir = DirAccess.open(path)
	if not dir:
		push_error("CropDatabase: couldn't open %s" % path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var resource: Resource = load(path + file_name)
			if resource is CropData:
				var crop_data: CropData = resource
				if crop_data.seed_pack_item:
					crop_by_seed_id[crop_data.seed_pack_item.item_id] = crop_data
				if crop_data.plant_tool != DataTypes.Tools.None:
					crop_by_tool[crop_data.plant_tool] = crop_data
		file_name = dir.get_next()
	dir.list_dir_end()

func get_crop_for_seed(seed_item: ItemData) -> CropData:
	return crop_by_seed_id.get(seed_item.item_id, null)

func get_crop_for_tool(tool: DataTypes.Tools) -> CropData:
	return crop_by_tool.get(tool, null)

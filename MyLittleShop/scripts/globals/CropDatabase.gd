extends Node

var crop_by_seed_id: Dictionary = {}  

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
			var crop_data: CropData = load(path + file_name)
			if crop_data and crop_data.seed_pack_item:
				crop_by_seed_id[crop_data.seed_pack_item.item_id] = crop_data
		file_name = dir.get_next()
	dir.list_dir_end()

func get_crop_for_seed(seed_item: ItemData) -> CropData:
	return crop_by_seed_id.get(seed_item.item_id, null)

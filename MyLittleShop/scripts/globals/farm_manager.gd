extends Node
@export var ground_layer: TileMapLayer
@export var wetness_overlay_layer: TileMapLayer
@export var crop_layer: TileMapLayer

enum GroundState { GRASS, TILLED_DRY, TILLED_WET }

const TERRAIN_SET_ID := 0
const GRASS_TERRAIN_ID := 0
const TILLED_TERRAIN_ID := 1

const WETNESS_SOURCE_ID := 3
const WET_OVERLAY_COORD := Vector2i(1, 15)

var ground_states: Dictionary = {}
var crops: Dictionary = {}
const CROP_SCENE := preload("res://scenes/objects/crops/crop.tscn")

# done on growth cycle component
#func _ready() -> void:
	#DayAndNightCycleManager.time_tick_day.connect(_on_new_day)

func _ready() -> void:
	print("FarmManager _ready called, self=", self)
	DayAndNightCycleManager.time_tick_day.connect(_on_new_day)
	print("FarmManager connected to time_tick_day")

# ---------- TOOL ACTIONS ----------
func till(cell: Vector2i) -> bool:
	if crops.has(cell):
		return false
	var state = ground_states.get(cell, GroundState.GRASS)
	if state != GroundState.GRASS:
		return false
	ground_layer.set_cells_terrain_connect([cell], TERRAIN_SET_ID, TILLED_TERRAIN_ID)
	ground_states[cell] = GroundState.TILLED_DRY
	return true

func water(cell: Vector2i) -> bool:
	var state = ground_states.get(cell, GroundState.GRASS)
	if state == GroundState.GRASS:
		return false
	wetness_overlay_layer.set_cell(cell, WETNESS_SOURCE_ID, WET_OVERLAY_COORD)
	ground_states[cell] = GroundState.TILLED_WET
	if crops.has(cell):
		crops[cell].water()
	return true

func plant_with_crop_data(cell: Vector2i, crop_data: CropData) -> bool:
	var state = ground_states.get(cell, GroundState.GRASS)
	if state == GroundState.GRASS:
		return false
	if crops.has(cell):
		return false
	var crop: Crop = CROP_SCENE.instantiate()
	crop.crop_data = crop_data
	crop.cell = cell
	crop.position = ground_layer.map_to_local(cell)
	crop_layer.add_child(crop)
	crops[cell] = crop
	crop.plant(DayAndNightCycleManager.current_day)
	return true

func plant(cell: Vector2i, seed_item: ItemData) -> bool:
	var state = ground_states.get(cell, GroundState.GRASS)
	if state == GroundState.GRASS:
		return false
	if crops.has(cell):
		return false
	var crop_data: CropData = CropDatabase.get_crop_for_seed(seed_item)
	if crop_data == null:
		push_warning("No CropData found for seed item: %s" % seed_item.item_id)
		return false
	var crop: Crop = CROP_SCENE.instantiate()
	crop.crop_data = crop_data
	crop.cell = cell
	crop.position = ground_layer.map_to_local(cell)
	crop_layer.add_child(crop)
	crops[cell] = crop
	crop.plant(DayAndNightCycleManager.current_day)
	return true

#func harvest(cell: Vector2i) -> ItemData:
	#if not crops.has(cell):
		#return null
	#var crop: Crop = crops[cell]
	#if not crop.is_harvestable():
		#return null
	#var product: ItemData = crop.crop_data.harvest_product_item
	#if crop.crop_data.regrows_after_harvest:
		#crop.reset_after_harvest()
	#else:
		#crop.queue_free()
		#crops.erase(cell)
	#return product

func harvest(cell: Vector2i) -> ItemData:
	if not crops.has(cell):
		return null
	var crop: Crop = crops[cell]
	var product: ItemData = crop.try_harvest()
	if product == null:
		return null
	if not crop.crop_data.regrows_after_harvest:
		crop.queue_free()
		crops.erase(cell)
	return product

# ---------- DAY CYCLE ----------
func _on_new_day(_day: int) -> void:
	print("FarmManager _on_new_day fired")
	for cell in ground_states.keys():
		if ground_states[cell] == GroundState.TILLED_WET:
			wetness_overlay_layer.erase_cell(cell)
			ground_states[cell] = GroundState.TILLED_DRY
			# time tick day handled by growth cycle component

# manages the farm
extends Node

enum TileState { UNTILLED, TILLED, PLANTED }

var tile_states: Dictionary = {}   # tileState
var tile_crops: Dictionary = {}    # crop node
var tile_nodes: Dictionary = {}    # FarmTile node

const CROP_SCENES: Dictionary = {
	"corn_seed": preload("res://scenes/objects/crops/corn_crop.tscn"),
	"wheat_seed": preload("res://scenes/objects/crops/wheat_crop.tscn"),
	"blueberry_seed": preload("res://scenes/objects/crops/blueberry_crop.tscn"),
	"strawberry_seed": preload("res://scenes/objects/crops/strawberry_crop.tscn"),
	"watermelon_seed": preload("res://scenes/objects/crops/watermelon_crop.tscn"),
	"rice_seed": preload("res://scenes/objects/crops/rice_crop.tscn"),
	"carrot_seed": preload("res://scenes/objects/crops/carrot_crop.tscn"),
	"lettuce_seed": preload("res://scenes/objects/crops/lettuce_crop.tscn"),
	"potato_seed": preload("res://scenes/objects/crops/potato_crop.tscn"),
}

@onready var crop_container: Node2D = $CropContainer 

signal item_harvested(item: ItemData)

signal tile_state_changed(cell: Vector2i, state: TileState)

func register_tile(cell: Vector2i, tile: FarmTile) -> void:
	tile_nodes[cell] = tile

func till(cell: Vector2i) -> void:
	if get_state(cell) != TileState.UNTILLED:
		return
	tile_states[cell] = TileState.TILLED
	
	if tile_nodes.has(cell):
		tile_nodes[cell].show_tilled()

func plant(cell: Vector2i, seed_item: ItemData) -> bool:
	if get_state(cell) != TileState.TILLED:
		return false
	var scene = CROP_SCENES.get(seed_item.item_id, null)
	if not scene:
		return false
	
	var crop = scene.instantiate()
	crop_container.add_child(crop)
	crop.global_position = cell_to_world(cell)
	crop.plant(DayAndNightCycleManager.current_day)
	
	tile_states[cell] = TileState.PLANTED
	tile_crops[cell] = crop
	crop.growth_cycle.crop_harvestable.connect(func(): _on_crop_harvestable(cell))
	return true

func water(cell: Vector2i) -> void:
	if get_state(cell) != TileState.PLANTED:
		return
	tile_crops[cell].water()

func harvest(cell: Vector2i) -> void:
	if get_state(cell) != TileState.PLANTED:
		return
	var crop = tile_crops[cell]
	var product = crop.try_harvest()
	if not product:
		return
	item_harvested.emit(product)
	if not is_instance_valid(crop):   # crop removed itself (non-regrow)
		tile_crops.erase(cell)
		tile_states[cell] = TileState.TILLED

func get_state(cell: Vector2i) -> TileState:
	return tile_states.get(cell, TileState.UNTILLED)

func world_to_cell(world_pos: Vector2) -> Vector2i:
	return Vector2i(world_pos / 16.0)  # replace 16 with your tile size

func cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2(cell) * 16.0 # not sure if its 8x8 or 16x16

func _on_crop_harvestable(cell: Vector2i) -> void:
	pass 

#class_name GrowthCycleComponent
#extends Node
#
#@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Sprout
#@export_range(5, 365) var days_until_harvest: int = 7
#
#signal crop_maturity
#signal crop_harvesting
#
#var is_watered: bool
#var starting_day: int
#var current_day: int
#
#func _ready() -> void:
	#DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)
#
#func on_time_tick_day(day: int) -> void:
	#if is_watered:
		#if starting_day == 0:
			#starting_day = days_until_harvest
		#
		#growth_states(starting_day, day)
		#harvest_state(starting_day, day)
#
#func growth_states(starting_day: int, current_day: int):
	#if current_growth_state == DataTypes.GrowthStates.Harvestable:
		#return
	#
	#var num_states = 5
	#
	#var growth_days_passed = (current_day - starting_day) % num_states
	#var state_index = growth_days_passed % num_states + 1
	#
	#current_growth_state = state_index
	#
	#var name = DataTypes.GrowthStates.keys()[current_growth_state]
	#print("Current growth state: ", name, "State index: ", state_index)
	#
	#if current_growth_state == DataTypes.GrowthStates.Harvestable:
		#crop_maturity.emit()
#
#func harvest_state(starting_day: int, current_day: int):
	#if current_growth_state == DataTypes.GrowthStates.Product:
		#return
	#
	#var days_passed = (current_day - starting_day) % days_until_harvest
	#
	#if days_passed == days_until_harvest - 1:
		#current_growth_state = DataTypes.GrowthStates.Product
		#crop_harvesting.emit()
#
#func get_current_growth_state() -> DataTypes.GrowthStates:
	#return current_growth_state

# growth_cycle_component.gd
class_name GrowthCycleComponent
extends Node

@export var crop_data: CropData

signal growth_stage_changed(new_state: DataTypes.GrowthStates)
signal crop_harvestable
signal crop_harvested

var current_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Sprout
var is_watered: bool = false
var plant_day: int = -1        # day this crop was planted
var days_grown: int = 0        # total watered days accumulated

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(_on_new_day)

func plant(current_day: int) -> void:
	plant_day = current_day
	days_grown = 0
	current_state = DataTypes.GrowthStates.Sprout
	growth_stage_changed.emit(current_state)

func _on_new_day(day: int) -> void:
	if plant_day == -1:
		return  # not planted yet
	if not is_watered:
		return  # stardew: unwaterd crops don't grow
	
	is_watered = false  # reset each day — player must re-water
	days_grown += 1
	_recalculate_stage()

func _recalculate_stage() -> void:
	if current_state == DataTypes.GrowthStates.Harvestable:
		return
	
	var total_days = crop_data.days_to_harvest
	# Divide growth evenly across the 4 pre-harvest stages
	# Sprout(0%), Seedling(25%), Vegetating(50%), Mature(75%), Harvestable(100%)
	var progress = float(days_grown) / float(total_days)
	
	var new_state: DataTypes.GrowthStates
	if progress >= 1.0:
		new_state = DataTypes.GrowthStates.Harvestable
	elif progress >= 0.75:
		new_state = DataTypes.GrowthStates.Mature
	elif progress >= 0.5:
		new_state = DataTypes.GrowthStates.Vegetating
	elif progress >= 0.25:
		new_state = DataTypes.GrowthStates.Seedling
	else:
		new_state = DataTypes.GrowthStates.Sprout
	
	if new_state != current_state:
		current_state = new_state
		growth_stage_changed.emit(current_state)
		if current_state == DataTypes.GrowthStates.Harvestable:
			crop_harvestable.emit()

func harvest() -> ItemData:
	if current_state != DataTypes.GrowthStates.Harvestable:
		return null
	
	if crop_data.regrows_after_harvest:
		days_grown = crop_data.days_to_harvest - crop_data.regrow_days
		current_state = DataTypes.GrowthStates.Mature
		growth_stage_changed.emit(current_state)
	else:
		queue_free()  # or signal the tile to remove the crop
	
	crop_harvested.emit()
	return crop_data.harvest_product_item

func water() -> void:
	is_watered = true

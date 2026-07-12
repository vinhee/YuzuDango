class_name GrowthCycleComponent
extends Node
@export var crop_data: CropData
signal growth_stage_changed(new_state: DataTypes.GrowthStates)
signal crop_harvestable
signal crop_harvested
var current_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Sprout
var is_watered: bool = false
var plant_day: int = -1
var days_grown: int = 0

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(_on_new_day)

func plant(current_day: int) -> void:
	plant_day = current_day
	days_grown = 0
	current_state = DataTypes.GrowthStates.Sprout
	growth_stage_changed.emit(current_state)

func _on_new_day(day: int) -> void:
	print("GrowthCycle _on_new_day fired: day=", day, " is_watered=", is_watered, " plant_day=", plant_day)
	if plant_day == -1:
		return
	if not is_watered:
		return
	is_watered = false
	days_grown += 1
	_recalculate_stage()

func _recalculate_stage() -> void:
	if current_state == DataTypes.GrowthStates.Harvestable:
		return
	var total_days = crop_data.days_to_harvest
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
	crop_harvested.emit()
	return crop_data.harvest_product_item

func water() -> void:
	is_watered = true

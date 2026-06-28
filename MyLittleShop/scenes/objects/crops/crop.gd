#extends Node2D
#
## test using wheat first, need to generalise later on
#var crop_harvest_scene = preload("res://scenes/objects/crops/wheat_harvest.tscn")
#
#@onready var sprite_2d: Sprite2D = $Sprite2D
#@onready var watering_particles: GPUParticles2D = $WateringParticles
#@onready var flowering_particles: GPUParticles2D = $FloweringParticles
#@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
#@onready var damageable_area: DamageableArea = $DamageableArea
#
#var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.SeedPack
#
#func _ready() -> void:
	#watering_particles.emitting = false
	#flowering_particles.emitting = false
	#
	#damageable_area.hurt.connect(on_watered)
	#growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	#growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)
#
#func _process(delta: float) -> void:
	#growth_state = growth_cycle_component.get_current_growth_state()
	#sprite_2d.frame = growth_state
	#
	#if growth_state == DataTypes.GrowthStates.Harvestable:
		#flowering_particles.emitting = true
#
#func on_watered(hit_dmg: int) -> void:
	#if !growth_cycle_component.is_watered:
		#watering_particles.emitting = true
		#await get_tree().create_timer(5.0).timeout
		#watering_particles.emitting = false
		#growth_cycle_component.is_watered = true
#
#func on_crop_maturity() -> void:
	#flowering_particles.emitting = true
#
#func on_crop_harvesting() -> void:
	#var crop_harvest_instance = crop_harvest_scene.instantiate() as Node2D
	#crop_harvest_instance.global_position = global_position
	#get_parent().add_child(crop_harvest_instance)

# crop.gd  ← attached to the root node of your crop scene
class_name Crop
extends Node2D

@export var crop_data: CropData   # ← set this in each inherited scene's inspector

@onready var sprite: Sprite2D = $Sprite2D
@onready var growth_cycle: GrowthCycleComponent = $GrowthCycleComponent
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var damageable_area: Area2D = $DamageableArea   # your reusable component

func _ready() -> void:
	# Pass crop data down to the component
	growth_cycle.crop_data = crop_data

	# Connect signals
	growth_cycle.growth_stage_changed.connect(_on_growth_stage_changed)
	growth_cycle.crop_harvestable.connect(_on_crop_harvestable)
	damageable_area.watered.connect(_on_watered)   # assuming your component emits this
	
	# Set initial sprite
	_update_sprite(DataTypes.GrowthStates.Sprout)

func plant(current_day: int) -> void:
	growth_cycle.plant(current_day)

func _on_watered() -> void:
	growth_cycle.water()
	watering_particles.emitting = true

func _on_growth_stage_changed(new_state: DataTypes.GrowthStates) -> void:
	_update_sprite(new_state)
	watering_particles.emitting = false

func _on_crop_harvestable() -> void:
	flowering_particles.emitting = true

func _update_sprite(state: DataTypes.GrowthStates) -> void:
	match state:
		DataTypes.GrowthStates.Sprout:       sprite.texture = crop_data.sprite_sprout
		DataTypes.GrowthStates.Seedling:     sprite.texture = crop_data.sprite_seedling
		DataTypes.GrowthStates.Vegetating:   sprite.texture = crop_data.sprite_vegetating
		DataTypes.GrowthStates.Mature:       sprite.texture = crop_data.sprite_mature
		DataTypes.GrowthStates.Harvestable:  sprite.texture = crop_data.sprite_harvestable

func try_harvest() -> ItemData:
	return growth_cycle.harvest()

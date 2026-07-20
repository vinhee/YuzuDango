class_name Crop
extends Node2D
@export var crop_data: CropData
@onready var sprite: Sprite2D = $Sprite2D
@onready var growth_cycle: GrowthCycleComponent = $GrowthCycleComponent
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var damageable_area: Area2D = $DamageableArea
@onready var interactable_area: CropInteractable = $InteractableArea
var cell: Vector2i
var current_stage: int = 0
var days_alive: int = 0
var watered_today: bool = false

func _ready() -> void:
	sprite.texture = crop_data.sprite_sprout
	interactable_area.crop = self
	growth_cycle.crop_data = crop_data
	growth_cycle.growth_stage_changed.connect(_on_growth_stage_changed)
	growth_cycle.crop_harvestable.connect(_on_crop_harvestable)
	# old system, reusing damageable area to detect watering
	# now changed to farm manager handling it
	# in the future need to remove damageable area node from crop scene
	#damageable_area.watered.connect(_on_watered)
	
	# alrd set flowering particles emitting to false on the node itself
	# this is a backup to make sure its false
	# only when harvestable the code changes it to true
	flowering_particles.emitting = false
	_update_sprite(DataTypes.GrowthStates.Sprout)

func plant(current_day: int) -> void:
	growth_cycle.plant(current_day)

func water() -> void:
	growth_cycle.water()
	watering_particles.emitting = true

func is_harvestable() -> bool:
	return growth_cycle.current_state == DataTypes.GrowthStates.Harvestable

func try_harvest() -> ItemData:
	return growth_cycle.harvest()

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

func interact(player: Player) -> void:
	if not is_harvestable():
		print("Crop isn't ready yet!")
		return
		
	var harvested_product = growth_cycle.harvest()
	print("Debug: ", harvested_product)
	
	if harvested_product and player.inventory:
		player.inventory.insert(harvested_product)
		
		if not crop_data.regrows_after_harvest:
			if FarmManager.crops.has(cell):
				FarmManager.crops.erase(cell)
			queue_free()
		else:
			print("Regrow Crop")
	else:
		print("WARNING: Missing crop_data.harvest_item or Player Inventory!")

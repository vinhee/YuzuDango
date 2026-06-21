extends Sprite2D

@onready var damageable_area: DamageableArea = $DamageableArea
@onready var damage_component: DamageComponent = $DamageComponent

var stone_scene = preload("res://scenes/objects/rocks/stone.tscn")
# note for now rock uses same tool to break as trees

func _ready() -> void:
	# hurt signal (in damageable area component) connect with on hurt func below
	damageable_area.hurt.connect(on_hurt)
	# connect max dmg rched signal w on max dmg rched func
	damage_component.max_damage_reached.connect(on_max_damage_reached)
	
# receives hit damage
func on_hurt(hit_damage: int) -> void:
	# then we apply on dmg component aka max hp
	damage_component.apply_damage(hit_damage)

func on_max_damage_reached() -> void:
	call_deferred("add_stone_scene")
	print("max dmg rched")
	# remove the scene aka "rock dies"
	queue_free()

func add_stone_scene() -> void:
	var stone_instance = stone_scene.instantiate() as Node2D
	stone_instance.global_position = global_position
	get_parent().add_child(stone_instance)

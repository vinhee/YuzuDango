# objects that can be damaged have a damageable area
# its like their hitbox
# no collision shape here bc when we create other nodes/ scenes they will have diff areas
# attach collision shape to each object based on whr iw the hitbox to be
class_name DamageableArea
extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.None

# dmgable area's collision layer is 5 (Object)
# mask is layer 4 (Tool) bc the object is hit by tools

# will store the type of tool needed to damage the current object

signal hurt

func _on_area_entered(area: Area2D) -> void:
	var hit_area = area as HitArea
	
	if tool == hit_area.current_tool:
		print("damage received")
		hurt.emit(hit_area.hit_damage)

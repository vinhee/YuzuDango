class_name DamageComponent
extends Node2D

# basically stores hp of object

@export var max_damage = 1
@export var current_damage = 0

signal max_damage_reached

func apply_damage(damage:int) -> void:
	print("current damage: ", current_damage)
	current_damage = clamp(current_damage + damage, 0, max_damage)
	
	if current_damage == max_damage:
		max_damage_reached.emit()

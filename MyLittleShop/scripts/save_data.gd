class_name SaveData
extends Node

@onready var parent_node = get_parent() as Node2D

@export var save_data_resource: Resource

func _ready() -> void:
	add_to_group("save_data")

func _save_data() -> Resource:
	if parent_node == null:
		return null
	
	if save_data_resource == null:
		push_error("save data resource: ", save_data_resource, parent_node.name)
		return
	
	save_data_resource._save_date(parent_node)
	
	return save_data_resource

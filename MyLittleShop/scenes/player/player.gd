class_name Player
extends CharacterBody2D

# default facing front
var player_direction: Vector2 = Vector2.DOWN
var speed := 50
var forageable_in_area = null
# so that walking cannot override player action
# e.g. chopping -> cannot move
var is_busy: bool = false

@export var inventory: Inventory
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

func _physics_process(delta: float) -> void:
	pass

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		print("DEBUG: INTERACT PRESSED")
		var interactable = get_interactable()
		if interactable:
			print("DEBUG: trying interacting on =", interactable)
			interactable.interact(self)
		else:
			print("DEBUG: no interactable in range")

func get_interactable():
	for area in $InteractionArea.get_overlapping_areas():
		if area is Interactable:
			return area
	return null

func _input(event):
	if event is InputEventMouseButton:
		print("Mouse button event:", event.button_index, event.pressed)

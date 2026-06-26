class_name Player
extends CharacterBody2D

# default facing front
var player_direction: Vector2 = Vector2.DOWN
var speed := 50
var forageable_in_area = null
# so that walking cannot override player action
# e.g. chopping -> cannot move
var is_busy: bool = false
const TILE_SIZE: int = 16

@onready var hit_area: HitArea = $HitArea
@export var inventory: Inventory
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)

func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_area.current_tool = tool
	print("Tool: ", tool)

# func to get the cell infront of player so that when doing actions like
# tilling or watering can call this method to get the tile
# reusable for tilling watering planting states
func get_facing_cell() -> Vector2i:
	var target_world_pos = global_position + player_direction * TILE_SIZE
	return Vector2i(target_world_pos / TILE_SIZE)

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

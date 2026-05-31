class_name Player
extends CharacterBody2D

var direction: Vector2
var speed := 50
var forageable_in_area = null

@export var inventory: Inventory

func _physics_process(delta: float) -> void:
	move()
	
func move():
	direction = Input.get_vector("walk_left","walk_right", "walk_up", "walk_down")
	velocity = direction * speed
	move_and_slide()

func _ready():
	$pickable_area.area_entered.connect(_on_area_entered)
	$pickable_area.area_exited.connect(_on_area_exited)

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if forageable_in_area != null: #and forageable_in_area.state == "mushroom"
			forageable_in_area.pickup()

func _on_area_entered(area):
	if area.has_method("pickup"):
		forageable_in_area = area
		print("Entered pickup range")
		
func _on_area_exited(area):
	if area == forageable_in_area:
		forageable_in_area = null
		print("Left pickup range")

func _on_pickable_area_entered(area):
	print("Collect item")
	if area.has_method("collect"):
		area.collect(inventory)

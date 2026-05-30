extends Area2D

@export var player: Player
var state = "no mushroom"
var player_in_range = "false"

func _ready():
	#if state == "no mushroom":
		#$spawn_timer.start()
	$spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func pickup():
	#if state != "mushroom":
		#return
		
	print("Mushroom picked up!")
	
	state = "no mushroom"
	$AnimatedSprite2D.play("no mushroom")
	#set_deferred("monitoring", false)
	
	$spawn_timer.start()
	
func _on_spawn_timer_timeout():
	state = "mushroom"
	$AnimatedSprite2D.play("mushroom")
	#set_deferred("monitoring", true)

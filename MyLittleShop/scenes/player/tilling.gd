extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")


func _on_enter() -> void:
	#print("Stored direction: ", player.player_direction)
	
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("dig_back")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("dig_front")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("dig_left")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("dig_right")
	#else:
		#print("Direction check failed:", player.player_direction)
	else:
		animated_sprite_2d.play("dig_front")


func _on_exit() -> void:
	animated_sprite_2d.stop()

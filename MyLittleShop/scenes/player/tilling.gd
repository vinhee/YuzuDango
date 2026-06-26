extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var has_tilled: bool = false

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


#func _on_next_transitions() -> void:
	#if !animated_sprite_2d.is_playing():
		#transition.emit("Idle")


func _on_enter() -> void:
	#print("Stored direction: ", player.player_direction)
	
	has_tilled = false
	
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


#func _on_exit() -> void:
	#animated_sprite_2d.stop()

func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		if not has_tilled:
			has_tilled = true
			_do_till()
		transition.emit("Idle")

func _do_till() -> void:
	var target_cell = _get_target_cell()
	FarmManager.till(target_cell)

func _get_target_cell() -> Vector2i:
	return player.get_facing_cell()

func _on_exit() -> void:
	animated_sprite_2d.stop()

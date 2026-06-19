extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 50

func _on_process(_delta : float) -> void:
	pass

func _on_enter() -> void:
	#print("Walk entered, sprite: ", animated_sprite_2d)
	animated_sprite_2d.stop()

func _on_physics_process(_delta: float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	#print("Walk direction: ", direction, " sprite: ", animated_sprite_2d)
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
		# Horizontal movement dominates
			if direction.x > 0:
				animated_sprite_2d.play("walk_right")
			else:
				animated_sprite_2d.play("walk_left")
		else:
		# Vertical movement dominates
			if direction.y < 0:
				animated_sprite_2d.play("walk_back")
			else:
				animated_sprite_2d.play("walk_front")

	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			player.player_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
		else:
			player.player_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP
	
	player.velocity = direction * speed
	player.move_and_slide()

func _on_next_transitions() -> void:
	if GameInputEvents.is_movement_input():
		transition.emit("Walk")
	else:
		#if no mvt input, emit Idle state
		transition.emit("Idle")

func _on_exit() -> void:
	pass

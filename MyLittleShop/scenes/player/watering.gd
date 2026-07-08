extends NodeState
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
var has_watered: bool = false

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	pass

func _on_enter() -> void:
	has_watered = false
	match player.player_direction:
		Vector2.UP: animated_sprite_2d.play("water_back")
		Vector2.DOWN: animated_sprite_2d.play("water_front")
		Vector2.LEFT: animated_sprite_2d.play("water_left")
		Vector2.RIGHT: animated_sprite_2d.play("water_right")
		_: animated_sprite_2d.play("water_front")

func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		if not has_watered:
			has_watered = true
			_do_water()
		transition.emit("Idle")

func _do_water() -> void:
	var target_cell = _get_target_cell()
	var success = FarmManager.water(target_cell)
	if not success:
		pass 

func _get_target_cell() -> Vector2i:
	return player.get_facing_cell()

func _on_exit() -> void:
	animated_sprite_2d.stop()

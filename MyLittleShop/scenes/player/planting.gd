extends NodeState
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var test_seed_item: ItemData # temporary, dragged in seed for testing
var has_planted: bool = false

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	pass

func _on_enter() -> void:
	has_planted = false
	match player.player_direction:
		# note: for now all directions just play the plant anim (front facing)
		# in the future when hv time to design more animations can add
		Vector2.UP: animated_sprite_2d.play("plant")
		Vector2.DOWN: animated_sprite_2d.play("plant")
		Vector2.LEFT: animated_sprite_2d.play("plant")
		Vector2.RIGHT: animated_sprite_2d.play("plant")
		_: animated_sprite_2d.play("plant")
		#Vector2.UP: animated_sprite_2d.play("plant_back")
		#Vector2.DOWN: animated_sprite_2d.play("plant_front")
		#Vector2.LEFT: animated_sprite_2d.play("plant_left")
		#Vector2.RIGHT: animated_sprite_2d.play("plant_right")
		#_: animated_sprite_2d.play("plant_front")

func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		if not has_planted:
			has_planted = true
			_do_plant()
		transition.emit("Idle")

func _do_plant() -> void:
	var seed_item: ItemData = ToolManager.selected_seed
	if seed_item == null:
		return
	var target_cell = player.get_facing_cell()
	var success = FarmManager.plant(target_cell, seed_item)
	if success:
		print("Planted: ", seed_item.item_id)
		# vin help do: player.inventory.remove_one(seed_item)

func _on_exit() -> void:
	animated_sprite_2d.stop()

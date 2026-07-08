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
		Vector2.UP: animated_sprite_2d.play("plant_back")
		Vector2.DOWN: animated_sprite_2d.play("plant_front")
		Vector2.LEFT: animated_sprite_2d.play("plant_left")
		Vector2.RIGHT: animated_sprite_2d.play("plant_right")
		_: animated_sprite_2d.play("plant_front")

func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		if not has_planted:
			has_planted = true
			_do_plant()
		transition.emit("Idle")

func _do_plant() -> void:
	var crop_data = CropDatabase.get_crop_for_tool(player.current_tool)
	# vin help do inventory method to get seed item that player is holding
	# replace test_seed_item with player.inventory.get_held_item()
	if test_seed_item == null:
		return
	var target_cell = player.get_facing_cell()
	var success = FarmManager.plant(target_cell, test_seed_item)
	if success:
		print("Planted (stub, no inventory consumption yet)")
		# vin help with inventory remove item method
		# smt like player.inventory.remove_one(test_seed_item)

func _on_exit() -> void:
	animated_sprite_2d.stop()

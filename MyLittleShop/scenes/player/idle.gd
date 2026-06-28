extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

func _on_enter() -> void:
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("idle_back")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("idle_right")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left")
	else:
		animated_sprite_2d.play("idle_front")

func _on_next_transitions() -> void:
	if GameInputEvents.is_movement_input():
		transition.emit("Walk")

	if player.current_tool == DataTypes.Tools.AxeWood && GameInputEvents.use_tool():
		transition.emit("Chopping")

	if player.current_tool == DataTypes.Tools.TillGround && GameInputEvents.use_tool():
		transition.emit("Tilling")

	if player.current_tool == DataTypes.Tools.WaterCrops && GameInputEvents.use_tool():
		transition.emit("Watering")

	# no tool equipped so check if player is holding seed to plant
	#if player.current_tool == DataTypes.Tools.None && GameInputEvents.use_tool():
		#_try_plant()

#func _try_plant() -> void:
	#var held_item = player.inventory.get_held_item()
	#if held_item == null:
		#return
	#if held_item.item_type != ItemData.ItemType.SEED:
		#return
	#
	#var target_cell = player.get_facing_cell()
	#var success = FarmManager.plant(target_cell, held_item)
	#if success:
		#player.inventory.remove_one(held_item)

func _on_exit() -> void:
	animated_sprite_2d.stop()

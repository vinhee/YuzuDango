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

	#if player.current_tool == DataTypes.Tools.None && GameInputEvents.use_tool():
		#var held_item = player.inventory.get_held_item()
		#if held_item != null and held_item.item_type == ItemData.ItemType.SEED:
			#transition.emit("Planting")
	
	# TEMPORARY: no real "holding a seed" check yet, just plant sberry for testing
	if _is_planting_tool(player.current_tool) && GameInputEvents.use_tool():
		transition.emit("Planting")

func _is_planting_tool(tool: DataTypes.Tools) -> bool:
	return CropDatabase.crop_by_tool.has(tool)

func _on_exit() -> void:
	animated_sprite_2d.stop()

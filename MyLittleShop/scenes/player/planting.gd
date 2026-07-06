# in the future use this for planting state
# for now no animation for planting hence just leaving idle state to check
# idle state has method to try planting

extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var has_planted: bool = false

func _on_enter() -> void:
	has_planted = false
	# play planting animation same pattern as till/water...
	animated_sprite_2d.play("plant_front") # etc per direction

func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		if not has_planted:
			has_planted = true
			_do_plant()
		transition.emit("Idle")

func _do_plant() -> void:
	var target_cell = player.get_facing_cell()
	var equipped_item: ItemData = player.get_equipped_item() # you'll need this accessor
	if equipped_item and equipped_item.item_type == ItemData.ItemType.SEED:
		if FarmManager.plant(target_cell, equipped_item):
			player.inventory.consume_one(equipped_item) # adjust to your inventory API

func _on_exit() -> void:
	animated_sprite_2d.stop()

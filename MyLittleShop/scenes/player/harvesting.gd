extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

func _on_enter() -> void:
	harvest_crop()

func _on_next_transitions() -> void:
	if not animated_sprite_2d.is_playing():
		transition.emit("Idle")

func harvest_crop() -> void:
	var interactable = player.get_interactable_in_front() 
	
	if interactable and interactable.has_method("harvest"):
		interactable.harvest(player)

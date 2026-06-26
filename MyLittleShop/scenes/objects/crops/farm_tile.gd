class_name FarmTile
extends Area2D

@onready var tilled_sprite: Sprite2D = $TilledSprite

func show_tilled() -> void:
	tilled_sprite.visible = true

func show_untilled() -> void:
	tilled_sprite.visible = false

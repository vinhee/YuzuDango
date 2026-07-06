extends Node2D

@onready var ground_layer: TileMapLayer = $GameTileMap/Grass

func _ready() -> void:
	FarmManager.ground_layer = ground_layer

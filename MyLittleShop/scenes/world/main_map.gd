extends Node2D

#@onready var ground_layer: TileMapLayer = $GameTileMap/Grass

func _ready() -> void:
	FarmManager.ground_layer = $GameTileMap/Ground
	FarmManager.wetness_overlay_layer = $GameTileMap/WetnessOverlay
	FarmManager.crop_layer = $GameTileMap/Crop
	
	print("Runtime tile_set resource path: ", FarmManager.ground_layer.tile_set.resource_path)

	var ts = FarmManager.ground_layer.tile_set
	print("Total terrain sets: ", ts.get_terrain_sets_count())
	for set_idx in ts.get_terrain_sets_count():
		print("Terrain Set ", set_idx, ":")
		for terrain_idx in ts.get_terrains_count(set_idx):
			print("  Terrain ", terrain_idx, " = ", ts.get_terrain_name(set_idx, terrain_idx))

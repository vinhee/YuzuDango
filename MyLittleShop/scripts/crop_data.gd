# crop_data.gd
class_name CropData
extends Resource

@export var crop_name: String = "Unknown Crop"
@export var days_to_harvest: int = 7

# Sprites for each growth stage
@export var sprite_sprout: Texture2D
@export var sprite_seedling: Texture2D
@export var sprite_vegetating: Texture2D
@export var sprite_mature: Texture2D
@export var sprite_harvestable: Texture2D

# Inventory items
@export var seed_pack_item: ItemData      # what's in player's inventory before planting
@export var harvest_product_item: ItemData # what drops on harvest

# Optional per-crop behaviour flags
@export var needs_water_every_day: bool = true
@export var regrows_after_harvest: bool = false     # e.g. tomatoes, blueberries
@export var regrow_days: int = 3                    # days to regrow if above is true

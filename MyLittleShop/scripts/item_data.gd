class_name ItemData
extends Resource

enum ItemType { SEED, CROP, TOOL, MISC }

@export var item_id: String = ""          # unique key e.g. "tomato_seed", "tomato"
@export var item_name: String = ""        # display name e.g. "Tomato Seed"
@export var description: String = ""
@export var icon: Texture2D
@export var item_type: ItemType = ItemType.MISC
@export var max_stack_size: int = 99      # seeds/crops stack; tools usually = 1
@export var sell_price: int = 0
@export var buy_price: int = 0

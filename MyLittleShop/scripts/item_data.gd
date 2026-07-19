class_name ItemData
extends Resource

enum ItemType { SEED, CROP, TOOL, MISC, FOOD, FORAGEABLE }

@export var item_id: String = ""          
@export var item_name: String = ""        
@export var description: String = ""
@export var icon: Texture2D
@export var item_type: ItemType = ItemType.MISC
@export var max_stack_size: int = 99      
@export var sell_price: int = 0
@export var buy_price: int = 0

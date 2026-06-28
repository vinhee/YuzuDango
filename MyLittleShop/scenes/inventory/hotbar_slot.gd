extends Panel
class_name HotbarSlot

@onready var backgroundSprite: Sprite2D = $background
@onready var item_stack_gui: ItemStack = $CenterContainer/Panel

var current_slot_data: InventorySlot = null
var is_selected: bool = false

func update_to_slot(slot: InventorySlot) -> void:
	current_slot_data = slot
	_refresh_visuals()
	
func set_selected(selected: bool) -> void:
	is_selected = selected
	_refresh_visuals()

func _refresh_visuals() -> void:
	if !current_slot_data || !current_slot_data.item:
		item_stack_gui.visible = false
	else:
		item_stack_gui.inventorySlot = current_slot_data
		item_stack_gui.update()
		item_stack_gui.visible = true

	if is_selected:
		backgroundSprite.frame = 2
	else:
		# Normal frames
		backgroundSprite.self_modulate = Color.WHITE
		backgroundSprite.frame = 1 if (current_slot_data and current_slot_data.item) else 0

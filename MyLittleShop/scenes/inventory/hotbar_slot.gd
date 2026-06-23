extends Panel
class_name HotbarSlot

@onready var backgroundSprite: Sprite2D = $background
@onready var item_stack_gui: ItemStack = $CenterContainer/Panel

func update_to_slot(slot: InventorySlot) -> void:
	if !slot || !slot.item:
		item_stack_gui.visible = false
		backgroundSprite.frame = 0
		return
		
	item_stack_gui.inventorySlot = slot
	item_stack_gui.update()
	item_stack_gui.visible = true
	backgroundSprite.frame = 1

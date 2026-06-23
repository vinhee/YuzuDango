extends Panel

class_name ItemStack

@onready var itemSprite: Sprite2D = $item
@onready var amtLabel: Label = $item/Label

var inventorySlot: InventorySlot

func update():
	if !inventorySlot || !inventorySlot.item: return
	
	itemSprite.visible = true
	itemSprite.texture = inventorySlot.item.texture
	
	if inventorySlot.amount > 1:
		amtLabel.visible = true
		amtLabel.text = str(inventorySlot.amount)
	else:
		amtLabel.visible = false

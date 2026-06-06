extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@onready var amtLabel: Label = $CenterContainer/Panel/item/Label

func update(slot: InventorySlot):
	if !slot.item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
		amtLabel.visible = false
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = slot.item.texture
		amtLabel.visible = true
		amtLabel.text = str(slot.amount)

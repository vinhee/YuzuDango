extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@onready var amtLabel: Label = $CenterContainer/Panel/Label

func update(slot: InventorySlot):
	if !slot || !slot.item || slot.amount <= 0:
		backgroundSprite.frame = 0
		itemSprite.visible = false
		amtLabel.visible = false
		return
	backgroundSprite.frame = 1
	itemSprite.visible = true
	itemSprite.texture = slot.item.texture
	
	if slot.amount > 1:
		amtLabel.visible = true
		amtLabel.text = str(slot.amount)
	else:
		amtLabel.visible = false

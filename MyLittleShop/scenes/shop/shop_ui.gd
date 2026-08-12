extends CanvasLayer
 
@onready var control: Control = $ShopUi
@onready var title_label: Label = $ShopUi/Panel/MarginContainer/Root/TopBar/TitleLabel
@onready var gold_label: Label = $ShopUi/Panel/MarginContainer/Root/TopBar/GoldLabel
@onready var inventory_list: ItemList = $ShopUi/Panel/MarginContainer/Root/InventoryList
@onready var sell_button: Button = $ShopUi/Panel/MarginContainer/Root/SellButton
@onready var quantity_spinbox: SpinBox = $ShopUi/Panel/MarginContainer/Root/BottomBar/QuantitySpinBox
@onready var close_button: Button = $ShopUi/Panel/MarginContainer/Root/BottomBar/CloseButton
 
var player: Player
 
 
func _ready() -> void:
	inventory_list.item_selected.connect(_on_inventory_item_selected)
	sell_button.pressed.connect(_on_sell_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	sell_button.disabled = true
 
 
func open(shop_player: Player, shop_name: String = "Selling Board") -> void:
	if player != shop_player:
		if player and player.gold_changed.is_connected(_on_player_gold_changed):
			player.gold_changed.disconnect(_on_player_gold_changed)
		player = shop_player
		player.gold_changed.connect(_on_player_gold_changed)
 
	title_label.text = shop_name
	control.visible = true
	quantity_spinbox.min_value = 1
	quantity_spinbox.value = 1
	sell_button.disabled = true
	_refresh_all()
 
 
func _refresh_all() -> void:
	_populate_inventory_list()
	_update_gold_label()
 
 
func _on_player_gold_changed(_new_amount: int) -> void:
	if control.visible:
		_refresh_all()
 
 
func _update_gold_label() -> void:
	gold_label.text = "Gold: %d" % player.gold
 
 
func _owned_slots() -> Array[InventorySlot]:
	# Inventory has no get_all_items() — filter its slots array to non-empty ones.
	return player.inventory.slots.filter(func(slot): return slot.item != null)
 
 
func _populate_inventory_list() -> void:
	inventory_list.clear()
	sell_button.disabled = true
	for slot in _owned_slots():
		var item: ItemData = slot.item
		var idx := inventory_list.add_item(
			"%s x%d - %d g" % [item.item_name, slot.amount, item.sell_price],
			item.icon
		)
		if item.sell_price <= 0:
			inventory_list.set_item_disabled(idx, true)
			inventory_list.set_item_custom_fg_color(idx, Color.GRAY)
 
 
func _inventory_item_at(index: int) -> ItemData:
	var owned := _owned_slots()
	if index < 0 or index >= owned.size():
		return null
	return owned[index].item
 
 
func _on_inventory_item_selected(index: int) -> void:
	var item := _inventory_item_at(index)
	sell_button.disabled = item == null or item.sell_price <= 0
	if item:
		sell_button.text = "Sell %s" % item.item_name
 
 
func _on_sell_button_pressed() -> void:
	var selected := inventory_list.get_selected_items()
	if selected.is_empty():
		return
	var item := _inventory_item_at(selected[0])
	if item == null:
		return
	_sell(item, int(quantity_spinbox.value))
 
 
func _sell(item: ItemData, qty: int) -> void:
	if qty <= 0 or item.sell_price <= 0:
		return
	var have := player.inventory.get_item_count(item)
	qty = min(qty, have)
	if qty <= 0:
		return
 
	player.inventory.remove_item(item, qty)
	player.add_gold(item.sell_price * qty)
	_refresh_all()
 
 
func _on_close_button_pressed() -> void:
	control.visible = false
	get_tree().paused = false
 
 
func _unhandled_input(event: InputEvent) -> void:
	if not control.visible:
		return
	if event.is_action_pressed("ui_cancel"):
		_on_close_button_pressed()
		get_viewport().set_input_as_handled()

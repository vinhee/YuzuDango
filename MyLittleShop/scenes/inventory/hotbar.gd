extends HBoxContainer

@onready var inventory: Inventory = preload("res://scenes/player/playerInventory.tres")
@onready var slots: Array = get_children()

var active_slot_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.updated.connect(update)
	update()

func _unhandled_input(event: InputEvent) -> void:
	var old_index = active_slot_index

	if event.is_action_pressed("scroll_up") or event.is_action_pressed("hotbar_prev"):
		active_slot_index = posmod(active_slot_index - 1, slots.size())
	elif event.is_action_pressed("scroll_down") or event.is_action_pressed("hotbar_next"):
		active_slot_index = posmod(active_slot_index + 1, slots.size())

	for i in range(slots.size()):
		if event.is_action_pressed("hotbar_" + str(i + 1)):
			active_slot_index = i
			
	if old_index != active_slot_index:
		update_selection_visuals()

func update() -> void:
	for i in range(slots.size()):
		var inventory_slots: InventorySlot = inventory.slots[i]
		slots[i].update_to_slot(inventory_slots)

func update_selection_visuals() -> void:
	for i in range(slots.size()):
		if slots[i] is HotbarSlot:
			slots[i].set_selected(i == active_slot_index)

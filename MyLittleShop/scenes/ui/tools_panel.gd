extends PanelContainer

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_till: Button = $MarginContainer/HBoxContainer/ToolTill
@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
@onready var seed_wheat: Button = $MarginContainer/HBoxContainer/SeedWheat
@onready var seed_potato: Button = $MarginContainer/HBoxContainer/SeedPotato
@onready var seed_blueberry: Button = $MarginContainer/HBoxContainer/SeedBlueberry

func _on_tool_axe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.AxeWood)


func _on_tool_till_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.TillGround)


func _on_tool_watering_can_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.WaterCrops)


func _on_seed_wheat_pressed() -> void:
	pass # Replace with function body.


func _on_seed_potato_pressed() -> void:
	pass # Replace with function body.


func _on_seed_blueberry_pressed() -> void:
	pass # Replace with function body.

# to "unselect" a tool
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			ToolManager.select_tool(DataTypes.Tools.None)
			tool_axe.release_focus()
			tool_till.release_focus()
			tool_watering_can.release_focus()
			seed_wheat.release_focus()
			seed_potato.release_focus()
			seed_blueberry.release_focus()

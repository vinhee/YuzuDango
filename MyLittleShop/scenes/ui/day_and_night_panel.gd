extends Control

@onready var day_label: Label = $DayPanel/MarginContainer/DayLabel
@onready var time_label: Label = $TimePanel/MarginContainer/TimeLabel

func _ready() -> void:
	DayAndNightCycleManager.time_tick.connect(on_time_tick)

func on_time_tick(day: int, hour: int, min: int) -> void:
	day_label.text = "DAY " + str(day)
	# string formatter to convert int to string
	time_label.text = "%02d:%02d" % [hour, min]

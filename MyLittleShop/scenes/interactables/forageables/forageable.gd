extends Interactable
class_name Forageable

@export var item_id: String = "mushroom"
@export var amount: int = 1
@export var respawn_time: float = 10.0

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var timer = $RespawnTimer

var available := true

func _ready():
	timer.timeout.connect(_on_respawn)

func interact():
	try_pickup()

func try_pickup():
	print("DEBUG: try_pickup called, available =", available)
	if not available:
		print("DEBUG: blocked (not available)")
		return

	pickup()
	
func pickup():
	available = false

	print("Picked up ", amount, " ", item_id)

	# add item to inventory here

	sprite.visible = false
	collision.disabled = true

	timer.start(respawn_time)

func _on_respawn():
	print("DEBUG: respawn triggered for ", item_id)
	available = true

	sprite.visible = true
	collision.disabled = false

var player_in_range := false
var picked := false

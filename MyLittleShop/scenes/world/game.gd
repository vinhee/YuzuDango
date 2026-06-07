extends Node

@onready var world = $World
@onready var player = $Player

func _ready():
	SceneManager.setup(world, player)
	

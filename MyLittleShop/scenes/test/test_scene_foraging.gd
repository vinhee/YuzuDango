extends Node2D

@export var mushroom_scene: PackedScene

func _ready():
	#print("mushroom_scene = ", mushroom_scene)
	spawn_mushroom()
	
func spawn_mushroom():
	var mushroom = mushroom_scene.instantiate()
	mushroom.position = Vector2(300, 200)
	$Forageables.add_child(mushroom)
	mushroom.state = "mushroom"
	print("Spawned mushroom")

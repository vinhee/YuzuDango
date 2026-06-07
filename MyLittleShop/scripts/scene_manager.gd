#this manages the transitioning of scenes
extends Node

var initial_scene := "res://scenes/world/MainMap.tscn"
var initial_spawn_id := "StartSpawn"

var current_scene = null
var spawn_id = ""

var world
var player

func setup(world_node, player_node):
	print("Setup called")
	world = world_node
	player = player_node
	
	change_scene(initial_scene, initial_spawn_id)

func change_scene(scene_path: String, new_spawn_id: String):
	spawn_id = new_spawn_id
	
	if current_scene:
		current_scene.queue_free()
	
	var scene = load(scene_path).instantiate()
	world.add_child(scene)
	
	current_scene = scene
	
	await get_tree().process_frame
	apply_spawn()

func apply_spawn():
	if spawn_id == "":
		return

	var spawn = find_spawn_by_id(current_scene, spawn_id)

	if spawn == null:
		push_error("Spawn ID not found: " + spawn_id)
		return

	player.global_position = spawn.global_position
	spawn_id = ""


func find_spawn_by_id(root: Node, id: String) -> Marker2D:
	for child in root.find_children("*", "SpawnPoint", true, false):
		if child.spawn_id == id:
			return child
	return null

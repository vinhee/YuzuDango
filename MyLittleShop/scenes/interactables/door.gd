extends Interactable
class_name Door

@export var target_scene: String
@export var target_spawn_id: String

func interact():
	SceneManager.change_scene(
		target_scene,
		target_spawn_id
	)

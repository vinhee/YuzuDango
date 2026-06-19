extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_area_collision_shape: CollisionShape2D

#func _ready() -> void:
	#print("ready called")
	#hit_area_collision_shape.disabled = true
	#hit_area_collision_shape.position = Vector2(0, 0)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")


func _on_enter() -> void:
	print("hit_area_collision_shape: ", hit_area_collision_shape)
	print("is disabled: ", hit_area_collision_shape.disabled)
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("axe_back")
		hit_area_collision_shape.position = Vector2(0, -18)
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("axe_front")
		hit_area_collision_shape.position = Vector2(0,3)
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("axe_left")
		hit_area_collision_shape.position = Vector2(-9,0)
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("axe_right")
		hit_area_collision_shape.position = Vector2(9,0)
	else:
		animated_sprite_2d.play("axe_front")
	
	# only off the disable when player hitting animation is on
	# hit_area_collision_shape.disabled = false
	#hit_area_collision_shape.disabled = true  # keep disabled until swing frame
	animated_sprite_2d.frame_changed.connect(_on_frame_changed)

func _on_frame_changed() -> void:
	# "impact" frame aka when the axe "hits"
	var impact_frame = 1
	if animated_sprite_2d.frame == impact_frame:
		hit_area_collision_shape.disabled = false
	else:
		hit_area_collision_shape.disabled = true

func _on_exit() -> void:
	animated_sprite_2d.stop()
	hit_area_collision_shape.disabled = true
	# disconnect to avoid stacking signals
	if animated_sprite_2d.frame_changed.is_connected(_on_frame_changed):
		animated_sprite_2d.frame_changed.disconnect(_on_frame_changed)

#func _on_exit() -> void:
	#animated_sprite_2d.stop()
	#hit_area_collision_shape.disabled = true

extends CharacterBody2D
## Vanguard Specialist — square placeholder for the Patch-Driver operator.

@export var speed: float = 300.0
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 0.6
@export var fire_rate: float = 0.25
@export var bullet_scene: PackedScene  # assign TrainingBullet.tscn in the Inspector

var loaded_token: String = ""  # set by TrainingGround when the HUD loads a round
var is_dashing := false
var dash_timer := 0.0
var dash_cd_timer := 0.0
var fire_timer := 0.0
var dash_direction := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var input_dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	dash_cd_timer = max(dash_cd_timer - delta, 0.0)
	fire_timer = max(fire_timer - delta, 0.0)

	if Input.is_action_just_pressed("dash") and dash_cd_timer <= 0.0 and input_dir != Vector2.ZERO:
		is_dashing = true
		dash_timer = dash_duration
		dash_cd_timer = dash_cooldown
		dash_direction = input_dir

	if is_dashing:
		velocity = dash_direction * dash_speed
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
	else:
		velocity = input_dir * speed

	move_and_slide()

	look_at(get_global_mouse_position())

	if Input.is_action_pressed("shoot") and fire_timer <= 0.0 and loaded_token != "":
		_shoot()
		fire_timer = fire_rate


func _shoot() -> void:
	if bullet_scene == null:
		push_warning("TrainingPlayer: no bullet_scene assigned in the Inspector.")
		return
	var bullet := bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.token = loaded_token

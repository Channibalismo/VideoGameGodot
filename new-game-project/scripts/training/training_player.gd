extends CharacterBody2D

signal player_died

@export var speed: float = 380.0
@export var fire_rate: float = 0.22
@export var bullet_scene: PackedScene 

@export_group("Sandevistan")
@export var sandevistan_duration: float = 2.0
@export var sandevistan_time_scale: float = 0.3
@export var sandevistan_cooldown: float = 5.0
@export var afterimage_interval: float = 0.045
@export var afterimage_fade_time: float = 0.3
@export var afterimage_color: Color = Color(0.6, 0.95, 1.0, 0.35)

@export_group("Comment Shield")
@export var shield_duration: float = 1.2

var loaded_token: String = ""  
var is_dead := false
var fire_timer := 0.0
var shake_trauma := 0.0

var sandevistan_active := false
var sandevistan_cd_timer := 0.0
var afterimage_timer := 0.0
var afterimages: Array[Node] = []

var shield_active := false
var shield_timer := 0.0

@onready var camera: Camera2D = $Camera2D
@onready var muzzle_flash: ColorRect = $MuzzleFlash


func _ready() -> void:
	add_to_group("player")
	if camera:
		camera.ignore_rotation = true
	if muzzle_flash:
		muzzle_flash.visible = false


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	var input_dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	if input_dir.length_squared() > 1.0:
		input_dir = input_dir.normalized()

	fire_timer = max(fire_timer - delta, 0.0)
	sandevistan_cd_timer = max(sandevistan_cd_timer - delta, 0.0)

	if shield_active:
		shield_timer -= delta
		if shield_timer <= 0.0:
			_end_shield()

	if Input.is_action_just_pressed("sandevistan") and sandevistan_cd_timer <= 0.0 and not sandevistan_active:
		_activate_sandevistan()

	if sandevistan_active:
		afterimage_timer -= delta
		if afterimage_timer <= 0.0:
			afterimage_timer = afterimage_interval
			_spawn_afterimage()

	velocity = input_dir * speed
	move_and_slide()

	_aim_at_mouse()

	if Input.is_action_pressed("shoot") and fire_timer <= 0.0 and loaded_token != "":
		_shoot()
		fire_timer = fire_rate


func _aim_at_mouse() -> void:
	var to_mouse := get_global_mouse_position() - global_position
	if to_mouse.length_squared() < 0.0001:
		return
	rotation = to_mouse.angle()


func _process(delta: float) -> void:
	if shake_trauma > 0.0:
		shake_trauma = max(shake_trauma - delta * 2.5, 0.0)
		var power := shake_trauma * shake_trauma
		camera.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 16.0 * power
	elif camera.offset != Vector2.ZERO:
		camera.offset = Vector2.ZERO


func shake(amount: float) -> void:
	shake_trauma = clamp(shake_trauma + amount, 0.0, 1.0)


func die() -> void:
	if is_dead or shield_active:
		return
	is_dead = true
	velocity = Vector2.ZERO
	modulate = Color(1.0, 0.25, 0.25)
	shake(0.6)
	player_died.emit()


func _activate_sandevistan() -> void:
	sandevistan_active = true
	sandevistan_cd_timer = sandevistan_cooldown
	CombatTime.scale = sandevistan_time_scale
	modulate = Color(0.6, 0.95, 1.0)
	shake(0.15)
	afterimage_timer = 0.0
	await get_tree().create_timer(sandevistan_duration, true, false, true).timeout
	sandevistan_active = false
	CombatTime.scale = 1.0
	_clear_afterimages()
	if not shield_active:
		modulate = Color(1.0, 1.0, 1.0)


func _spawn_afterimage() -> void:
	var ghost := Node2D.new()
	ghost.global_position = global_position
	ghost.rotation = rotation

	var visual := ColorRect.new()
	visual.offset_left = -20.0
	visual.offset_top = -20.0
	visual.offset_right = 20.0
	visual.offset_bottom = 20.0
	visual.color = afterimage_color
	visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ghost.add_child(visual)

	get_tree().current_scene.add_child(ghost)
	afterimages.append(ghost)

	var tween := create_tween()
	tween.tween_property(visual, "modulate:a", 0.0, afterimage_fade_time)
	tween.finished.connect(func():
		afterimages.erase(ghost)
		if is_instance_valid(ghost):
			ghost.queue_free()
	)


func _clear_afterimages() -> void:
	for ghost in afterimages:
		if is_instance_valid(ghost):
			ghost.queue_free()
	afterimages.clear()


func _activate_shield() -> void:
	shield_active = true
	shield_timer = shield_duration
	modulate = Color(0.5, 0.9, 1.0)


func _end_shield() -> void:
	shield_active = false
	if not sandevistan_active:
		modulate = Color(1.0, 1.0, 1.0)


func _shoot() -> void:
	if loaded_token == "//":
		_activate_shield()
		return

	if bullet_scene == null:
		push_warning("TrainingPlayer: no bullet_scene assigned in the Inspector.")
		return

	shake(0.08)
	_flash_muzzle()

	var aim_dir := (get_global_mouse_position() - global_position).normalized()
	_fire_bullet(aim_dir)


func _fire_bullet(direction: Vector2) -> void:
	var bullet := bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = direction
	bullet.token = loaded_token


func _flash_muzzle() -> void:
	if muzzle_flash == null:
		return
	muzzle_flash.visible = true
	await get_tree().create_timer(0.05).timeout
	if is_instance_valid(self):
		muzzle_flash.visible = false

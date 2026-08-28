extends CharacterBody2D

const EnemyBulletScene := preload("res://scenes/combat/EnemyBullet.tscn")

signal neutralized_changed(is_neutralized: bool)

enum WeaponType { KNIFE, GUN }

@export var required_token: String = ";"
@export var error_text: String = "ERROR: missing ;"
@export var patrol_speed: float = 90.0
@export var chase_speed: float = 210.0
@export var detect_radius: float = 260.0
@export var patrol_radius: float = 100.0

@export_group("Weapon")
@export var randomize_weapon: bool = true
@export var weapon_type: WeaponType = WeaponType.KNIFE
@export var gun_range_min: float = 160.0
@export var gun_range_max: float = 320.0
@export var gun_fire_cooldown: float = 1.1

var neutralized := false
var home_position := Vector2.ZERO
var patrol_target := Vector2.ZERO
var player: Node2D = null
var gun_fire_timer := 0.0

@onready var square: ColorRect = $Square
@onready var error_label: Label = $ErrorLabel
@onready var hurtbox: Area2D = $Hurtbox


func _ready() -> void:
	add_to_group("enemies")
	home_position = global_position
	_pick_new_patrol_target()
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)
	player = get_tree().get_first_node_in_group("player")

	if randomize_weapon:
		weapon_type = WeaponType.GUN if randi() % 2 == 1 else WeaponType.KNIFE
	gun_fire_timer = randf_range(0.0, gun_fire_cooldown)

	_show_glitch()


func _physics_process(delta: float) -> void:
	if neutralized:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	gun_fire_timer = max(gun_fire_timer - delta * CombatTime.scale, 0.0)

	var dist := INF
	var player_visible := false
	if player and is_instance_valid(player):
		dist = global_position.distance_to(player.global_position)
		player_visible = dist <= detect_radius

	if not player_visible:
		_do_patrol()
	elif weapon_type == WeaponType.GUN:
		_do_gun(dist)
	else:
		_do_chase()

	move_and_slide()


func _do_patrol() -> void:
	var to_target := patrol_target - global_position
	if to_target.length() < 6.0:
		_pick_new_patrol_target()
		velocity = Vector2.ZERO
	else:
		velocity = to_target.normalized() * patrol_speed * CombatTime.scale
		if velocity.length() > 1.0:
			rotation = velocity.angle()


func _do_chase() -> void:
	var to_player := player.global_position - global_position
	velocity = to_player.normalized() * chase_speed * CombatTime.scale
	if velocity.length() > 1.0:
		rotation = velocity.angle()


func _do_gun(dist: float) -> void:
	var to_player := player.global_position - global_position
	if dist < gun_range_min:
		velocity = -to_player.normalized() * patrol_speed * CombatTime.scale
	elif dist > gun_range_max:
		velocity = to_player.normalized() * chase_speed * CombatTime.scale
	else:
		velocity = Vector2.ZERO

	if to_player.length() > 1.0:
		rotation = to_player.angle()

	if gun_fire_timer <= 0.0:
		_fire_at_player()
		gun_fire_timer = gun_fire_cooldown


func _fire_at_player() -> void:
	if player == null or not is_instance_valid(player):
		return
	var bullet := EnemyBulletScene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = (player.global_position - global_position).normalized()


func _pick_new_patrol_target() -> void:
	var angle := randf() * TAU
	var radius := randf() * patrol_radius
	patrol_target = home_position + Vector2(cos(angle), sin(angle)) * radius


func take_hit(token: String) -> void:
	if neutralized:
		return
	if token == required_token:
		_neutralize()


func _neutralize() -> void:
	neutralized = true
	square.color = Color(0.3, 0.85, 0.4)
	error_label.text = "BUILD SUCCESSFUL"
	error_label.modulate = Color(0.35, 1.0, 0.45)
	velocity = Vector2.ZERO
	if player and is_instance_valid(player) and player.has_method("shake"):
		player.shake(0.3)
	neutralized_changed.emit(true)


func _show_glitch() -> void:
	square.color = Color(0.65, 0.25, 0.85) if weapon_type == WeaponType.GUN else Color(0.85, 0.25, 0.2)
	error_label.text = error_text
	error_label.modulate = Color(1.0, 0.35, 0.3)


func _on_hurtbox_body_entered(body: Node) -> void:
	if neutralized:
		return
	if body.is_in_group("player") and body.has_method("die"):
		body.die()

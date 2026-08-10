extends CharacterBody2D
## Tier 1 minor-glitch mob. Hotline Miami rules: one touch and the player
## is dead. Patrols until it spots you, then gives chase. Neutralize it
## first with the correct Patch-Driver token or don't get close.

signal neutralized_changed(is_neutralized: bool)

@export var required_token: String = ";"
@export var error_text: String = "ERROR: missing ;"
@export var patrol_speed: float = 90.0
@export var chase_speed: float = 210.0
@export var detect_radius: float = 260.0
@export var patrol_radius: float = 100.0

var neutralized := false
var home_position := Vector2.ZERO
var patrol_target := Vector2.ZERO
var player: Node2D = null

@onready var square: ColorRect = $Square
@onready var error_label: Label = $ErrorLabel
@onready var hurtbox: Area2D = $Hurtbox


func _ready() -> void:
	add_to_group("enemies")
	home_position = global_position
	_pick_new_patrol_target()
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)
	player = get_tree().get_first_node_in_group("player")
	_show_glitch()


func _physics_process(_delta: float) -> void:
	if neutralized:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var target := patrol_target
	var speed := patrol_speed

	if player and is_instance_valid(player):
		if global_position.distance_to(player.global_position) <= detect_radius:
			target = player.global_position
			speed = chase_speed

	var to_target := target - global_position
	if target == patrol_target and to_target.length() < 6.0:
		_pick_new_patrol_target()
	else:
		velocity = to_target.normalized() * speed
		if velocity.length() > 1.0:
			rotation = velocity.angle()
	move_and_slide()


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
	square.color = Color(0.85, 0.25, 0.2)
	error_label.text = error_text
	error_label.modulate = Color(1.0, 0.35, 0.3)


func _on_hurtbox_body_entered(body: Node) -> void:
	if neutralized:
		return
	if body.is_in_group("player") and body.has_method("die"):
		body.die()

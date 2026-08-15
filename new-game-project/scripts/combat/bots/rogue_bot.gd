extends CharacterBody2D
class_name RogueBot
## Base class for A.U.R.O.R.A.-corrupted rogue bots.
## Subclasses implement behavior; this handles neutralize, contact kill,
## labels, and shared player/combat helpers.

signal neutralized_changed(is_neutralized: bool)

@export var bot_name: String = "RogueBot"
@export var required_tokens: PackedStringArray = [";"]
@export var error_text: String = "ERROR: corrupted unit"
@export var bot_color: Color = Color(0.85, 0.25, 0.2)
@export var lethal: bool = true
@export var counts_for_clear: bool = true

var neutralized := false
var player: Node2D = null

@onready var square: ColorRect = $Square
@onready var error_label: Label = $ErrorLabel
@onready var name_label: Label = $NameLabel
@onready var hurtbox: Area2D = $Hurtbox


func _ready() -> void:
	add_to_group("enemies")
	add_to_group("rogue_bots")
	if counts_for_clear:
		add_to_group("clear_targets")
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)
	player = get_tree().get_first_node_in_group("player")
	_apply_visuals()
	_bot_ready()


func _bot_ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if neutralized:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	_bot_physics(delta * CombatTime.scale)
	# _bot_physics sets `velocity` to a constant speed (direction * speed),
	# not scaled by delta. move_and_slide() then applies the engine's real,
	# unscaled physics delta, so without this the windup/fire timers slow
	# down under Sandevistan but actual movement speed doesn't. Scale the
	# resulting velocity itself so displacement matches the slowed time.
	velocity *= CombatTime.scale
	move_and_slide()


func _bot_physics(_delta: float) -> void:
	pass


func take_hit(token: String) -> void:
	if neutralized:
		return
	if _accepts_token(token):
		_on_correct_token(token)
	else:
		_on_wrong_token(token)


func _accepts_token(token: String) -> bool:
	return token in required_tokens


func _on_correct_token(_token: String) -> void:
	_neutralize()


func _on_wrong_token(_token: String) -> void:
	pass


func _neutralize(success_text: String = "BUILD SUCCESSFUL") -> void:
	if neutralized:
		return
	neutralized = true
	square.color = Color(0.3, 0.85, 0.4)
	error_label.text = success_text
	error_label.modulate = Color(0.35, 1.0, 0.45)
	velocity = Vector2.ZERO
	if player and is_instance_valid(player) and player.has_method("shake"):
		player.shake(0.3)
	neutralized_changed.emit(true)


func _apply_visuals() -> void:
	square.color = bot_color
	error_label.text = error_text
	error_label.modulate = Color(1.0, 0.4, 0.35)
	if name_label:
		name_label.text = bot_name


func _face(dir: Vector2) -> void:
	if dir.length_squared() > 0.01:
		rotation = dir.angle()


func _move_toward(target: Vector2, speed: float) -> void:
	var to_target := target - global_position
	if to_target.length_squared() < 4.0:
		velocity = Vector2.ZERO
		return
	velocity = to_target.normalized() * speed
	_face(velocity)


func _player_valid() -> bool:
	return player != null and is_instance_valid(player) and not (player.get("is_dead") == true)


func _player_dist() -> float:
	if not _player_valid():
		return INF
	return global_position.distance_to(player.global_position)


func _player_dir() -> Vector2:
	if not _player_valid():
		return Vector2.RIGHT
	return (player.global_position - global_position).normalized()


func _kill_player_if_lethal(body: Node = null) -> void:
	if not lethal or neutralized:
		return
	var target := body
	if target == null:
		target = player
	if target and target.is_in_group("player") and target.has_method("die"):
		target.die()


func _on_hurtbox_body_entered(body: Node) -> void:
	if neutralized:
		return
	_kill_player_if_lethal(body)


func _spawn_enemy_bullet(dir: Vector2) -> void:
	var bullet_scene: PackedScene = load("res://scenes/combat/EnemyBullet.tscn")
	var bullet := bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = dir
	if bullet.get("lethal") != null:
		bullet.lethal = lethal

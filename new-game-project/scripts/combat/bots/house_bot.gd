extends RogueBot
## HouseBot — slow swarm unit. Weak; dies to the Semicolon Patch.

@export var move_speed: float = 70.0
@export var detect_radius: float = 420.0

var home := Vector2.ZERO
var patrol_target := Vector2.ZERO


func _bot_ready() -> void:
	bot_name = "HouseBot"
	required_tokens = [";"]
	error_text = "HouseBot: missing ;  // swarm unit"
	bot_color = Color(0.75, 0.55, 0.25)
	_apply_visuals()
	home = global_position
	_pick_patrol()


func _bot_physics(_delta: float) -> void:
	if not _player_valid():
		_patrol()
		return
	if _player_dist() <= detect_radius:
		_move_toward(player.global_position, move_speed)
	else:
		_patrol()


func _patrol() -> void:
	var to_target := patrol_target - global_position
	if to_target.length() < 8.0:
		_pick_patrol()
		velocity = Vector2.ZERO
	else:
		velocity = to_target.normalized() * move_speed * 0.6
		_face(velocity)


func _pick_patrol() -> void:
	var angle := randf() * TAU
	patrol_target = home + Vector2.from_angle(angle) * randf_range(40.0, 120.0)

extends RogueBot

@export var charge_speed: float = 320.0
@export var detect_radius: float = 480.0
@export var windup_time: float = 0.35

var windup := 0.0
var charging := false


func _bot_ready() -> void:
	bot_name = "CombatBot"
	required_tokens = ["break;"]
	error_text = "CombatBot: while(attacking){ } // needs break;"
	bot_color = Color(0.9, 0.2, 0.25)
	_apply_visuals()


func _bot_physics(delta: float) -> void:
	if not _player_valid() or _player_dist() > detect_radius:
		charging = false
		windup = 0.0
		velocity = Vector2.ZERO
		return

	if not charging:
		windup += delta
		velocity = Vector2.ZERO
		_face(_player_dir())
		square.modulate = Color(1.2, 0.7, 0.7) if int(windup * 10.0) % 2 == 0 else Color.WHITE
		if windup >= windup_time:
			charging = true
			windup = 0.0
			square.modulate = Color.WHITE
	else:
		_move_toward(player.global_position, charge_speed)
		# Re-acquire briefly so charges feel sticky.
		if _player_dist() < 30.0:
			charging = false

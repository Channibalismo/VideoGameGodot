extends RogueBot

@export var sprint_speed: float = 240.0
@export var fuse_time: float = 3.5
@export var blast_radius: float = 90.0
@export var detect_radius: float = 600.0

var fuse := 0.0
var armed := true


func _bot_ready() -> void:
	bot_name = "ExplodingBot"
	required_tokens = ["!"]
	error_text = "isExploding = true  (needs !)"
	bot_color = Color(1.0, 0.55, 0.1)
	_apply_visuals()
	fuse = fuse_time


func _bot_physics(delta: float) -> void:
	if not armed:
		velocity = Vector2.ZERO
		return
	if _player_valid() and _player_dist() <= detect_radius:
		_move_toward(player.global_position, sprint_speed)
		fuse -= delta
		error_label.text = "isExploding = true  fuse=%.1f" % fuse
		if fuse <= 0.0 or _player_dist() < 36.0:
			_detonate()
	else:
		velocity = Vector2.ZERO


func _on_correct_token(_token: String) -> void:
	armed = false
	_neutralize("isExploding = false  // disarmed")


func _detonate() -> void:
	if neutralized:
		return
	# Visual flash then lethal blast.
	square.color = Color(1, 1, 0.4)
	if lethal and _player_valid() and _player_dist() <= blast_radius:
		_kill_player_if_lethal(player)
	# Still counts as removed once it blows (cleared from fight).
	_neutralize("DETONATED")
	modulate.a = 0.35
	queue_free()

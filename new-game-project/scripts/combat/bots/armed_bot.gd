extends RogueBot
## ArmedBot — cover shooter. Needs Assignment Bullet (=0).
## Peek-fire from near cover props in group "cover".

@export var move_speed: float = 120.0
@export var fire_cooldown: float = 0.85
@export var prefer_range: float = 260.0
@export var detect_radius: float = 520.0

var fire_timer := 0.0
var cover_point := Vector2.ZERO
var has_cover := false


func _bot_ready() -> void:
	bot_name = "ArmedBot"
	required_tokens = ["=0"]
	error_text = "ArmedBot: robotHealth > 0  (needs =0)"
	bot_color = Color(0.35, 0.45, 0.85)
	_apply_visuals()
	fire_timer = randf_range(0.2, fire_cooldown)
	_find_cover()


func _bot_physics(delta: float) -> void:
	fire_timer = max(fire_timer - delta, 0.0)
	if not _player_valid() or _player_dist() > detect_radius:
		velocity = Vector2.ZERO
		return

	if has_cover:
		var to_cover := cover_point - global_position
		if to_cover.length() > 18.0:
			velocity = to_cover.normalized() * move_speed
			_face(velocity)
		else:
			# Peek: stand near cover, face player, burst fire.
			velocity = Vector2.ZERO
			_face(_player_dir())
			if fire_timer <= 0.0:
				_spawn_enemy_bullet(_player_dir())
				fire_timer = fire_cooldown
	else:
		var dist := _player_dist()
		if dist < prefer_range * 0.7:
			velocity = -_player_dir() * move_speed
		elif dist > prefer_range:
			velocity = _player_dir() * move_speed
		else:
			velocity = Vector2.ZERO
		_face(_player_dir())
		if fire_timer <= 0.0:
			_spawn_enemy_bullet(_player_dir())
			fire_timer = fire_cooldown


func _find_cover() -> void:
	var best_dist := INF
	for node in get_tree().get_nodes_in_group("cover"):
		if node is Node2D:
			var d: float = global_position.distance_to(node.global_position)
			if d < best_dist:
				best_dist = d
				# Stand slightly offset from cover toward home side.
				cover_point = node.global_position + Vector2(-40, 0)
				has_cover = true

extends RogueBot
## ShieldBot — frontal energy plate. ! flips isFriendly and becomes an ally wall.

@export var advance_speed: float = 55.0
@export var detect_radius: float = 500.0

var is_friendly := false
var shield_area: Area2D


func _bot_ready() -> void:
	bot_name = "ShieldBot"
	required_tokens = ["!"]
	error_text = "isFriendly = false  (needs !)"
	bot_color = Color(0.25, 0.7, 0.85)
	_apply_visuals()
	_build_shield_plate()


func _build_shield_plate() -> void:
	shield_area = Area2D.new()
	shield_area.name = "ShieldPlate"
	shield_area.collision_layer = 0
	shield_area.collision_mask = 0  # bullets are areas; use area monitoring via physics layers
	# Enemy bullets are Area2D on default layers — monitor all areas.
	shield_area.monitoring = true
	shield_area.monitorable = true
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(14, 54)
	shape.shape = rect
	shape.position = Vector2(28, 0)
	shield_area.add_child(shape)
	add_child(shield_area)
	shield_area.area_entered.connect(_on_shield_area_entered)


func _bot_physics(_delta: float) -> void:
	if is_friendly:
		velocity = Vector2.ZERO
		# Face away from player so plate blocks fire coming at the player.
		if _player_valid():
			_face(-_player_dir())
		return

	if _player_valid() and _player_dist() <= detect_radius:
		_move_toward(player.global_position, advance_speed)
	else:
		velocity = Vector2.ZERO


func take_hit(token: String) -> void:
	if neutralized or is_friendly:
		return
	# Frontal hits that aren't Invert bounce.
	if token != "!" and _is_frontal_shot():
		error_label.text = "BLOCKED // frontal plate"
		error_label.modulate = Color(0.6, 0.85, 1.0)
		return
	super.take_hit(token)


func _is_frontal_shot() -> bool:
	# Approximate: if player is roughly in front of the bot facing.
	if not _player_valid():
		return true
	var to_player := _player_dir()
	var facing := Vector2.from_angle(rotation)
	return facing.dot(to_player) > 0.15


func _on_correct_token(_token: String) -> void:
	is_friendly = true
	lethal = false
	bot_color = Color(0.35, 0.9, 0.55)
	square.color = bot_color
	error_label.text = "isFriendly = true  // covering operator"
	error_label.modulate = Color(0.35, 1.0, 0.45)
	remove_from_group("clear_targets")
	# Count as cleared for sector win, but keep existing in world as ally.
	neutralized = true
	neutralized_changed.emit(true)


func _on_shield_area_entered(area: Area2D) -> void:
	if not is_friendly:
		# Hostile shield: bounce player Patch-Driver rounds from the front.
		if area.has_method("take_hit") == false and area.get("token") != null:
			# Training bullet carries token — destroy on front plate.
			if _is_frontal_shot():
				area.queue_free()
		return
	# Ally: eat enemy bullets.
	if area.get_script() and str(area.get_script().resource_path).ends_with("enemy_bullet.gd"):
		area.queue_free()
	elif area.is_in_group("enemy_bullets"):
		area.queue_free()

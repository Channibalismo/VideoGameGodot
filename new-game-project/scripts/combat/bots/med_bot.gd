extends RogueBot
## MedBot — backline healer. Type cast (Player) reassigns heal target.

@export var move_speed: float = 95.0
@export var heal_radius: float = 220.0
@export var heal_interval: float = 1.6
@export var prefer_distance: float = 340.0

var heal_timer := 0.0
var heals_player := false


func _bot_ready() -> void:
	bot_name = "MedBot"
	required_tokens = ["(Player)"]
	error_text = "(RogueBot) target  // cast to (Player)"
	bot_color = Color(0.4, 0.9, 0.55)
	_apply_visuals()
	heal_timer = heal_interval


func _bot_physics(delta: float) -> void:
	heal_timer = max(heal_timer - delta, 0.0)

	if heals_player:
		velocity = Vector2.ZERO
		if heal_timer <= 0.0 and _player_valid():
			if player.has_method("_activate_shield"):
				player._activate_shield()
			heal_timer = heal_interval
		return

	# Keep distance / LOS avoid: strafe away if player is close.
	if _player_valid():
		var dist := _player_dist()
		if dist < prefer_distance:
			velocity = -_player_dir() * move_speed
			_face(velocity)
		else:
			velocity = Vector2.ZERO
			# Face nearest damaged ally concept — just face away.
			_face(-_player_dir())

	if heal_timer <= 0.0:
		_repair_nearby()
		heal_timer = heal_interval


func _repair_nearby() -> void:
	for node in get_tree().get_nodes_in_group("rogue_bots"):
		if node == self or not is_instance_valid(node):
			continue
		if node.get("neutralized") == true:
			continue
		if global_position.distance_to(node.global_position) > heal_radius:
			continue
		# Brief harden: flash + restore modulate.
		if node.get("square"):
			node.square.modulate = Color(0.6, 1.0, 0.7)
		if node.has_method("receive_repair"):
			node.receive_repair()


func _on_correct_token(_token: String) -> void:
	heals_player = true
	lethal = false
	remove_from_group("clear_targets")
	_neutralize("target = (Player)  // healing operator")

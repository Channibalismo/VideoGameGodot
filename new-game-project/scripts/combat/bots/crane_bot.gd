extends RogueBot

signal request_terminal(bot: Node)

@export var drop_interval: float = 3.2
@export var hazard_damage_radius: float = 70.0

var drop_timer := 0.0
var powered := true
var terminal: Node2D = null


func _bot_ready() -> void:
	bot_name = "CraneBot"
	required_tokens = []  # bullets bounce — use terminal
	error_text = "crane.power = true  // use terminal"
	bot_color = Color(0.55, 0.55, 0.6)
	_apply_visuals()
	drop_timer = drop_interval * 0.5
	# Larger body
	if square:
		square.offset_left = -28
		square.offset_top = -28
		square.offset_right = 28
		square.offset_bottom = 28


func _bot_physics(delta: float) -> void:
	velocity = Vector2.ZERO
	if not powered:
		return
	drop_timer -= delta
	if drop_timer <= 0.0:
		drop_timer = drop_interval
		_drop_container()


func take_hit(_token: String) -> void:
	if neutralized:
		return
	error_label.text = "TOO HEAVY // use OmniKernel terminal"
	error_label.modulate = Color(1.0, 0.7, 0.3)


func disable_via_terminal() -> void:
	powered = false
	_neutralize("crane.setPower(false);")


func _drop_container() -> void:
	if not _player_valid():
		return
	# Drop hazard marker on player's current position (telegraphed briefly).
	var marker := ColorRect.new()
	marker.size = Vector2(80, 80)
	marker.position = player.global_position - marker.size * 0.5
	marker.color = Color(1.0, 0.3, 0.1, 0.35)
	marker.z_index = 5
	get_tree().current_scene.add_child(marker)

	var drop_pos := player.global_position
	await get_tree().create_timer(0.55, true, false, true).timeout
	if is_instance_valid(marker):
		marker.color = Color(0.4, 0.35, 0.3, 0.9)
	if powered and lethal and _player_valid():
		if player.global_position.distance_to(drop_pos) <= hazard_damage_radius:
			_kill_player_if_lethal(player)
	await get_tree().create_timer(0.8, true, false, true).timeout
	if is_instance_valid(marker):
		marker.queue_free()

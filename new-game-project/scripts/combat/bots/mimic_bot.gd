extends RogueBot

@export var lunge_speed: float = 300.0
@export var reveal_distance: float = 110.0
@export var inspect_angle_deg: float = 18.0

var revealed := false
var is_trap := true
var disguise_active := true


func _bot_ready() -> void:
	bot_name = "MimicBot"
	required_tokens = [";", "=0", "!", "[]", "break;", "String[]", "(Player)", "null"]
	# Any real patch works once revealed — it's a trap unit.
	error_text = "String role = \"Survivor\""
	bot_color = Color(0.45, 0.75, 0.95)  # looks "friendly"
	_apply_visuals()
	if name_label:
		name_label.text = "Survivor?"
	# Randomize a few as actual safe decoys that don't attack? Keep traps for sector.
	is_trap = true


func _bot_physics(_delta: float) -> void:
	_update_inspect_hud()

	if not disguise_active:
		if _player_valid():
			_move_toward(player.global_position, lunge_speed)
		return

	velocity = Vector2.ZERO
	if _player_valid() and _player_dist() <= reveal_distance:
		_reveal_trap()


func _update_inspect_hud() -> void:
	if not disguise_active or not _player_valid():
		return
	# "ADS": player facing within a narrow cone toward this bot.
	var to_bot := (global_position - player.global_position).normalized()
	var facing := Vector2.from_angle(player.rotation)
	var ang := rad_to_deg(acos(clampf(facing.dot(to_bot), -1.0, 1.0)))
	if ang <= inspect_angle_deg and _player_dist() < 420.0:
		if is_trap:
			error_text = "String role = \"Trap\""
			error_label.modulate = Color(1.0, 0.35, 0.3)
		else:
			error_text = "String role = \"Survivor\""
			error_label.modulate = Color(0.4, 1.0, 0.5)
		error_label.text = error_text
	else:
		error_label.text = "String role = \"Survivor\""
		error_label.modulate = Color(0.6, 0.85, 1.0)


func _reveal_trap() -> void:
	disguise_active = false
	bot_color = Color(0.7, 0.15, 0.55)
	square.color = bot_color
	if name_label:
		name_label.text = "MimicBot"
	error_label.text = "String role = \"Trap\"  // CORRUPTED"
	error_label.modulate = Color(1.0, 0.3, 0.3)


func take_hit(token: String) -> void:
	if neutralized:
		return
	# Shooting the disguise always works if you know it's a trap / any token.
	if disguise_active:
		_reveal_trap()
	super.take_hit(token)

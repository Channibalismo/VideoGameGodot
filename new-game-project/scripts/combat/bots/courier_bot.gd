extends RogueBot
## CourierBot — alarm scout. =0 or break; before timer hits zero.

signal alarm_triggered

@export var move_speed: float = 210.0
@export var detect_radius: float = 260.0
@export var alarm_time: float = 5.0
@export var flee_speed: float = 180.0

var spotted := false
var alarm_timer := 0.0
var alarm_sent := false


func _bot_ready() -> void:
	bot_name = "CourierBot"
	required_tokens = ["=0", "break;"]
	error_text = "alarmTimer = idle"
	bot_color = Color(0.95, 0.85, 0.2)
	_apply_visuals()
	# Non-contact killer by default fantasy, but still shove-lethal if tagged.
	# Keep lethal from export; sector can leave true for HM rules.


func _bot_physics(delta: float) -> void:
	if alarm_sent:
		velocity = Vector2.ZERO
		return

	if not spotted:
		if _player_valid() and _player_dist() <= detect_radius:
			spotted = true
			alarm_timer = alarm_time
			error_label.text = "alarmTimer = %.0f" % alarm_timer
		else:
			# Lazy patrol
			velocity = Vector2(cos(Time.get_ticks_msec() * 0.001), sin(Time.get_ticks_msec() * 0.0015)) * move_speed * 0.35
			_face(velocity)
		return

	# Spotted: flee while counting down.
	if _player_valid():
		velocity = -_player_dir() * flee_speed
		_face(velocity)
	alarm_timer = max(alarm_timer - delta, 0.0)
	error_label.text = "alarmTimer = %.1f" % alarm_timer
	error_label.modulate = Color(1.0, 0.5, 0.2)
	if alarm_timer <= 0.0:
		_trigger_alarm()


func _on_correct_token(token: String) -> void:
	if token == "=0":
		_neutralize("alarmTimer = 0  // silenced")
	else:
		_neutralize("break;  // transmission aborted")


func _trigger_alarm() -> void:
	if alarm_sent or neutralized:
		return
	alarm_sent = true
	error_label.text = "ALARM SENT — swarm incoming"
	error_label.modulate = Color(1, 0.2, 0.2)
	# Hyper-aggro every remaining hostile.
	for node in get_tree().get_nodes_in_group("rogue_bots"):
		if node == self or not is_instance_valid(node):
			continue
		if node.get("neutralized") == true:
			continue
		if "detect_radius" in node:
			node.detect_radius = 9999.0
		if node.has_method("on_alarm"):
			node.on_alarm()
	alarm_triggered.emit()
	# Courier still must be patched to clear, or auto-clear after alert.
	_neutralize("alarmTimer = 0  // already rang")

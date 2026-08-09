extends Area2D
## Training dummy: displays a live Java glitch above it. Correct token
## clears it (green "BUILD SUCCESSFUL"); wrong token just bounces off.

@export var required_token: String = ";"
@export var error_text: String = "ERROR: missing ;"
@export var respawn_delay: float = 1.5

var solved := false
var fixed_count := 0

@onready var square: ColorRect = $Square
@onready var error_label: Label = $ErrorLabel
@onready var status_label: Label = $StatusLabel


func _ready() -> void:
	_show_glitch()


func take_hit(token: String) -> void:
	if solved:
		return
	if token == required_token:
		_solve()
	else:
		_miss()


func _solve() -> void:
	solved = true
	fixed_count += 1
	square.color = Color(0.25, 0.85, 0.35)
	error_label.text = "BUILD SUCCESSFUL"
	error_label.modulate = Color(0.35, 1.0, 0.45)
	status_label.text = "FIXED: %d" % fixed_count
	await get_tree().create_timer(respawn_delay).timeout
	if is_instance_valid(self):
		_show_glitch()


func _miss() -> void:
	var tween := create_tween()
	tween.tween_property(square, "modulate", Color(1, 0.4, 0.4), 0.05)
	tween.tween_property(square, "modulate", Color(1, 1, 1), 0.1)


func _show_glitch() -> void:
	solved = false
	square.color = Color(0.8, 0.2, 0.2)
	square.modulate = Color(1, 1, 1)
	error_label.text = error_text
	error_label.modulate = Color(1.0, 0.3, 0.3)

extends RogueBot
## SignalBot — jams the Compiler HUD. String[] piercing beam kills it.

@export var hover_speed: float = 80.0
@export var hover_radius: float = 90.0

var home := Vector2.ZERO
var phase := 0.0


func _bot_ready() -> void:
	bot_name = "SignalBot"
	required_tokens = ["String[]"]
	error_text = "jammingFreq = ON  // needs String[]"
	bot_color = Color(0.85, 0.35, 0.95)
	_apply_visuals()
	home = global_position
	add_to_group("signal_jammers")
	# Soft collision — hovers, still lethal on touch.
	collision_layer = 8


func _bot_physics(delta: float) -> void:
	phase += delta
	var offset := Vector2(cos(phase * 1.3), sin(phase * 1.7)) * hover_radius
	var target := home + offset
	_move_toward(target, hover_speed)
	if name_label and int(phase * 8.0) % 2 == 0:
		error_label.text = "████ jamming ████"
	else:
		error_label.text = "jammingFreq = ON  // needs String[]"


func _neutralize(success_text: String = "BUILD SUCCESSFUL") -> void:
	remove_from_group("signal_jammers")
	super._neutralize("jammingFreq = OFF")

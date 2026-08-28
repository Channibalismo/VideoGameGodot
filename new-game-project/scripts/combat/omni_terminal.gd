extends Area2D

@export var expected_code: String = "crane.setPower(false);"
@export var crane_path: NodePath

@onready var prompt: Label = $Prompt
@onready var panel: Control = $CanvasLayer/Panel
@onready var input: LineEdit = $CanvasLayer/Panel/CodeInput
@onready var status: Label = $CanvasLayer/Panel/Status

var player_near := false
var crane: Node = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	panel.visible = false
	input.text_submitted.connect(_on_submitted)
	if crane_path:
		crane = get_node_or_null(crane_path)
	prompt.text = "[E] OmniKernel Terminal"


func _unhandled_input(event: InputEvent) -> void:
	if not player_near:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_E and not panel.visible:
			_open()
		elif event.keycode == KEY_ESCAPE and panel.visible:
			_close()


func _open() -> void:
	panel.visible = true
	input.text = ""
	status.text = "Type deactivator block, ENTER"
	get_tree().paused = true
	panel.process_mode = Node.PROCESS_MODE_ALWAYS
	input.grab_focus()


func _close() -> void:
	panel.visible = false
	get_tree().paused = false


func _on_submitted(text: String) -> void:
	var cleaned := text.strip_edges()
	if cleaned == expected_code:
		status.text = "POWER CUT"
		if crane and crane.has_method("disable_via_terminal"):
			crane.disable_via_terminal()
		await get_tree().create_timer(0.4, true, false, true).timeout
		_close()
	else:
		status.text = "REJECTED — need: crane.setPower(false);"


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_near = true
		prompt.visible = true


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_near = false
		prompt.visible = false
		if panel.visible:
			_close()

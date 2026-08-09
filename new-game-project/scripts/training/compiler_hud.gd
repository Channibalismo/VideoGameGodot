extends Control
## "RACK MAGAZINE" overlay. Pauses the game, lets the player type a token,
## shows the real Java it maps to, and loads it into the Patch-Driver on
## ENTER. ESC cancels without loading.

signal token_loaded(token: String)

@onready var input: LineEdit = $Panel/TokenInput
@onready var java_label: Label = $Panel/JavaLabel
@onready var effect_label: Label = $Panel/EffectLabel
@onready var status_label: Label = $Panel/StatusLabel


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	input.text_changed.connect(_on_text_changed)
	input.text_submitted.connect(_on_text_submitted)


func open() -> void:
	visible = true
	input.text = ""
	java_label.text = ""
	effect_label.text = ""
	status_label.text = "Type a token, then press ENTER"
	get_tree().paused = true
	input.grab_focus()


func close() -> void:
	visible = false
	get_tree().paused = false


func _on_text_changed(new_text: String) -> void:
	var info := TokenData.get_info(new_text)
	if info.is_empty():
		java_label.text = ""
		effect_label.text = ""
	else:
		java_label.text = "%s\n\n%s" % [info.name, info.java]
		effect_label.text = "BULLET EFFECT: %s" % info.effect


func _on_text_submitted(text: String) -> void:
	if TokenData.is_valid(text):
		token_loaded.emit(text)
		close()
	else:
		status_label.text = "UNKNOWN TOKEN — try ; or !"


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close()

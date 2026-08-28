extends Control

@onready var entry_list: VBoxContainer = $Panel/Scroll/EntryList
@onready var close_button: Button = $Panel/CloseButton


func _ready() -> void:
	visible = false
	close_button.pressed.connect(close)
	_populate()


func _populate() -> void:
	for entry in BotCodexData.ENTRIES:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 14)

		var swatch := ColorRect.new()
		swatch.custom_minimum_size = Vector2(20, 20)
		swatch.color = entry["color"]
		row.add_child(swatch)

		var text := VBoxContainer.new()
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var name_line := Label.new()
		name_line.text = "%s  —  %s" % [entry["name"], entry["tokens"]]
		name_line.add_theme_font_size_override("font_size", 20)
		text.add_child(name_line)

		var note_line := Label.new()
		note_line.text = entry["note"]
		note_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		note_line.modulate = Color(0.8, 0.8, 0.85)
		text.add_child(note_line)

		row.add_child(text)
		entry_list.add_child(row)


func open() -> void:
	visible = true


func close() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close()

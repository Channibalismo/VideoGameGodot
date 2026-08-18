extends Control
## Lessons menu \u2014 grid of 14 lesson buttons, each with a thumbnail pulled
## from its corresponding res://Lessons/ subfolder. Replaces the old
## WorldMap.tscn as the primary lesson-select hub.

const LESSON_NAMES := [
	"Introduction to Computer Programming",
	"Data Types and Variables",
	"Output / print and println",
	"Arithmetic Operators",
	"Logical Operators",
	"If Statements",
	"Switch Statements",
	"Loops",
	"Methods",
	"Arrays",
	"Strings",
	"File Manipulation",
	"GUI",
]

const LESSON_THUMBNAILS := [
	"res://Lessons/01-intro/01-intro_page-0001.jpg",
	"res://Lessons/02-datatype/02-datatype_page-0001.jpg",
	"res://Lessons/03-output/03-output_page-0001.jpg",
	"res://Lessons/04-arithmetic/04-arithmetic_page-0001.jpg",
	"res://Lessons/05-logical/05-logical_page-0001.jpg",
	"res://Lessons/06-if/06-if_page-0001.jpg",
	"res://Lessons/07-switch/07-switch_page-0001.jpg",
	"res://Lessons/08-loop/08-loop_page-0001.jpg",
	"res://Lessons/09-methods/09-methods_page-0001.jpg",
	"res://Lessons/10-array/10-array_page-0001.jpg",
	"res://Lessons/11-string/11-string_page-0001.jpg",
	"res://Lessons/12-file/12-file_page-0001.jpg",
	"res://Lessons/13-gui/13-gui_page-0001.jpg",
]

@onready var grid: GridContainer = $Scroll/Grid
@onready var back_button: Button = $BackButton


func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	_populate()


func _populate() -> void:
	for i in LESSON_NAMES.size():
		var lesson_number := i + 1

		var card := VBoxContainer.new()
		card.custom_minimum_size = Vector2(220, 210)
		card.add_theme_constant_override("separation", 6)

		var thumb := TextureRect.new()
		thumb.texture = load(LESSON_THUMBNAILS[i])
		thumb.custom_minimum_size = Vector2(200, 120)
		thumb.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		thumb.stretch_mode = TextureRect.STRETCH_SCALE

		var unlocked := GameState.is_unlocked(lesson_number)
		var completed := GameState.is_completed(lesson_number)
		if not unlocked:
			thumb.modulate = Color(0.4, 0.4, 0.4)

		var btn := Button.new()
		var label_text := "%d. %s" % [lesson_number, LESSON_NAMES[i]]
		if completed:
			label_text += "  \u2714"
		elif not unlocked:
			label_text += "  \ud83d\udd12"
		btn.text = label_text
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.custom_minimum_size = Vector2(200, 70)
		btn.disabled = not unlocked
		btn.pressed.connect(_on_lesson_pressed.bind(lesson_number))

		card.add_child(thumb)
		card.add_child(btn)
		grid.add_child(card)


func _on_lesson_pressed(lesson_number: int) -> void:
	get_tree().change_scene_to_file("res://scenes/Lesson%d.tscn" % lesson_number)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

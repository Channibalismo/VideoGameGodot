extends Control
## Generic full-lesson slide viewer. Dynamically loads every page image
## from this lesson's res://Lessons/ subfolder — handles decks from 9
## pages (Arithmetic) to 90 pages (Loops) without hardcoding nodes.

const LESSON_FOLDERS := [
	"01-intro", "02-datatype", "03-output", "04-arithmetic", "05-logical",
	"06-if", "07-switch", "08-loop", "09-methods", "10-array",
	"11-string", "12-file", "13-gui",
]

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

@export var lesson_number: int = 1

@onready var title_label: Label = $Layout/TitleLabel
@onready var pages: VBoxContainer = $Layout/Scroll/Pages
@onready var back_button: Button = $Layout/ButtonRow/BackButton
@onready var complete_button: Button = $Layout/ButtonRow/CompleteButton
@onready var top_back_button: Button = $TopBack


func _ready() -> void:
	title_label.text = "Lesson %d: %s" % [lesson_number, LESSON_NAMES[lesson_number - 1]]
	back_button.pressed.connect(_on_back_pressed)
	top_back_button.pressed.connect(_on_back_pressed)
	complete_button.pressed.connect(_on_complete_pressed)

	if GameState.is_completed(lesson_number):
		complete_button.text = "Completed ✔"
		complete_button.disabled = true

	_load_pages()


func _load_pages() -> void:
	var folder := "res://Lessons/%s" % LESSON_FOLDERS[lesson_number - 1]
	var dir := DirAccess.open(folder)
	if dir == null:
		push_warning("LessonSlides: could not open %s" % folder)
		return

	var files: Array[String] = []
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".jpg"):
			files.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	files.sort()

	for f in files:
		var tex := TextureRect.new()
		tex.texture = load(folder + "/" + f)
		tex.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		tex.custom_minimum_size = Vector2(0, 500)
		pages.add_child(tex)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LessonsMenu.tscn")


func _on_complete_pressed() -> void:
	GameState.complete_lesson(lesson_number)
	get_tree().change_scene_to_file("res://scenes/LessonsMenu.tscn")

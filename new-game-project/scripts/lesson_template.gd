extends Control
## Template lesson scene. Duplicate this .tscn for Lesson2..Lesson9 and
## update `lesson_number` + the title/content text for each.

@export var lesson_number: int = 1

@onready var back_button: Button = $Layout/ButtonRow/BackButton
@onready var complete_button: Button = $Layout/ButtonRow/CompleteButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	complete_button.pressed.connect(_on_complete_pressed)

	if GameState.is_completed(lesson_number):
		complete_button.text = "Completed ✔"
		complete_button.disabled = true

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LessonsMenu.tscn")

func _on_complete_pressed() -> void:
	GameState.complete_lesson(lesson_number)
	get_tree().change_scene_to_file("res://scenes/LessonsMenu.tscn")

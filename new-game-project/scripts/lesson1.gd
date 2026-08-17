extends "res://scripts/lesson_template.gd"
## Lesson 1 also links out to its real slide deck.

@onready var slides_button: Button = $Layout/ButtonRow/SlidesButton


func _ready() -> void:
	super._ready()
	slides_button.pressed.connect(_on_slides_pressed)


func _on_slides_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LessonSelect.tscn")

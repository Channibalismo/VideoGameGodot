extends Control

const NUM_LESSONS := GameState.TOTAL_LESSONS

@onready var back_button: Button = $BackButton
@onready var lesson_list: GridContainer = $LessonList

var lesson_buttons: Array = []


func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	for i in range(NUM_LESSONS):
		var n := i + 1
		var btn: Button = lesson_list.get_child(i)
		lesson_buttons.append(btn)
		btn.pressed.connect(_on_lesson_pressed.bind(n))
	_refresh()


func _refresh() -> void:
	for i in range(NUM_LESSONS):
		var n := i + 1
		var btn: Button = lesson_buttons[i]
		var unlocked := GameState.is_unlocked(n)
		var completed := GameState.is_completed(n)
		btn.disabled = not unlocked
		if completed:
			btn.text = "✔ Lesson %d" % n
		elif unlocked:
			btn.text = "● Lesson %d" % n
		else:
			btn.text = "🔒 Lesson %d" % n


func _on_lesson_pressed(n: int) -> void:
	var path := "res://scenes/Lesson%d.tscn" % n
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		push_warning("LessonSelect: no scene found at %s" % path)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

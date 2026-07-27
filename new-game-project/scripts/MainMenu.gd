extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Learn.tscn")

func _on_lessons_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LessonSelect.tscn")
	
func _on_progress_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Progress.tscn")
	
func _on_challenge_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/CodingChallenge.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Settings.tscn")
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
@onready var tip_label = $TipPanel/TipLabel

var tips = [
	"Java is case-sensitive.",
	"Use meaningful variable names.",
	"Always close your braces {}.",
	"Comments make code easier to understand.",
	"Practice coding every day.",
	"Use Ctrl + S often to save your work.",
	"Debugging is part of programming.",
	"Read compiler errors carefully."
]

func _ready():
	show_random_tip()

func show_random_tip():
	tip_label.text = "Tip of the Day\n\n" + tips.pick_random()

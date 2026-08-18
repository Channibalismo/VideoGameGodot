extends Control
## Main menu navigation.

@onready var start_button: MenuButton = $Menu/StartButton
@onready var lessons_button: MenuButton = $Menu/LessonsButton
@onready var progress_button: MenuButton = $Menu/Progress
@onready var challenge_button: MenuButton = $Menu/ChallengeButton
@onready var settings_button: MenuButton = $Menu/Settings
@onready var exit_button: MenuButton = $Menu/ExitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	lessons_button.pressed.connect(_on_lessons_button_pressed)
	progress_button.pressed.connect(_on_progress_button_pressed)
	challenge_button.pressed.connect(_on_challenge_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/StartPlayingMenu.tscn")

func _on_lessons_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LessonsMenu.tscn")

func _on_progress_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Progress.tscn")

func _on_challenge_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/CodingChallenges.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Settings.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

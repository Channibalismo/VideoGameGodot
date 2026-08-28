extends Node2D

@onready var back_button: Button = $UI/BackButton
@onready var player: CharacterBody2D = $TrainingPlayer
@onready var hud: Control = $UI/CompilerHUD
@onready var loaded_label: Label = $UI/LoadedLabel


func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	hud.token_loaded.connect(_on_token_loaded)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reload") and not hud.visible:
		hud.open()


func _on_token_loaded(token: String) -> void:
	player.loaded_token = token
	loaded_label.text = "LOADED: %s" % token


func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

extends Control
## "Start Playing" submenu: pick a save slot, or jump into a test mode.

@onready var select_save_button: Button = $Menu/SelectSaveButton
@onready var training_button: Button = $Menu/TrainingButton
@onready var sector_button: Button = $Menu/SectorButton
@onready var back_button: Button = $Menu/BackButton
@onready var dictionary_button: Button = $Menu/DictionaryButton
@onready var bot_codex: Control = $BotCodex


func _ready() -> void:
	select_save_button.pressed.connect(_on_select_save_pressed)
	training_button.pressed.connect(_on_training_pressed)
	sector_button.pressed.connect(_on_sector_pressed)
	back_button.pressed.connect(_on_back_pressed)
	dictionary_button.pressed.connect(_on_dictionary_pressed)


func _on_select_save_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/SaveSlotSelect.tscn")


func _on_training_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/training/TrainingGround.tscn")


func _on_sector_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/combat/Sector01.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_dictionary_pressed() -> void:
	bot_codex.open()

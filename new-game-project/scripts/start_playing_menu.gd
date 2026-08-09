extends Control
## "Start Playing" submenu: New Game / Continue / Training Sim.

@onready var new_game_button: Button = $Menu/NewGameButton
@onready var continue_button: Button = $Menu/ContinueButton
@onready var continue_info: Label = $Menu/ContinueInfo
@onready var training_button: Button = $Menu/TrainingButton
@onready var back_button: Button = $Menu/BackButton
@onready var new_game_confirm: ConfirmationDialog = $NewGameConfirm


func _ready() -> void:
	new_game_button.pressed.connect(_on_new_game_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	training_button.pressed.connect(_on_training_pressed)
	back_button.pressed.connect(_on_back_pressed)
	new_game_confirm.confirmed.connect(_on_new_game_confirmed)

	# Re-read from disk so the preview below is never stale, even in a
	# long-running session where GameState was loaded a while ago.
	if FileAccess.file_exists(GameState.SAVE_PATH):
		GameState.load_game()

	var has_save := FileAccess.file_exists(GameState.SAVE_PATH)
	continue_button.disabled = not has_save
	continue_button.modulate.a = 1.0 if has_save else 0.5

	if has_save:
		var lesson := GameState.get_current_lesson()
		continue_info.text = "Lesson %d/%d  •  %d XP  •  %d coins" % [
			lesson, GameState.TOTAL_LESSONS, GameState.xp, GameState.coins
		]
	else:
		continue_info.text = ""


func _has_existing_progress() -> bool:
	return (
		GameState.completed_lessons.size() > 0
		or GameState.xp > 0
		or GameState.coins > 0
	)


func _on_new_game_pressed() -> void:
	if _has_existing_progress():
		new_game_confirm.popup_centered()
	else:
		_start_new_game()


func _on_new_game_confirmed() -> void:
	_start_new_game()


func _start_new_game() -> void:
	GameState.completed_lessons = []
	GameState.xp = 0
	GameState.coins = 0
	GameState.save_game()
	get_tree().change_scene_to_file("res://scenes/WorldMap.tscn")


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/WorldMap.tscn")


func _on_training_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/training/TrainingGround.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

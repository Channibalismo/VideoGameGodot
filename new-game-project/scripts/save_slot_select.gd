extends Control

const NUM_SLOTS := GameState.NUM_SAVE_SLOTS

@onready var back_button: Button = $BackButton
@onready var reset_confirm: ConfirmationDialog = $ResetConfirm

var slot_play_buttons: Array = []
var slot_reset_buttons: Array = []
var pending_reset_slot := -1


func _ready() -> void:
	for i in range(NUM_SLOTS):
		var row := get_node("Slots/Slot%d" % (i + 1))
		var play_btn: Button = row.get_node("PlayButton")
		var reset_btn: Button = row.get_node("ResetButton")
		slot_play_buttons.append(play_btn)
		slot_reset_buttons.append(reset_btn)
		play_btn.pressed.connect(_on_slot_pressed.bind(i))
		reset_btn.pressed.connect(_on_reset_pressed.bind(i))

	back_button.pressed.connect(_on_back_pressed)
	reset_confirm.confirmed.connect(_on_reset_confirmed)

	_refresh_slots()


func _refresh_slots() -> void:
	for i in range(NUM_SLOTS):
		var data := GameState.peek_slot(i)
		if data.is_empty():
			slot_play_buttons[i].text = "SLOT %d — Empty (New Game)" % (i + 1)
			slot_reset_buttons[i].visible = false
		else:
			var completed: Array = data.get("completed_lessons", [])
			var lesson: int = min(completed.size() + 1, GameState.TOTAL_LESSONS)
			slot_play_buttons[i].text = "SLOT %d — Lesson %d/%d  •  %d XP  •  %d coins" % [
				i + 1, lesson, GameState.TOTAL_LESSONS, data.get("xp", 0), data.get("coins", 0)
			]
			slot_reset_buttons[i].visible = true


func _on_slot_pressed(i: int) -> void:
	var data := GameState.peek_slot(i)
	GameState.current_slot = i
	if data.is_empty():
		GameState.reset_progress()
		GameState.save_game()
	else:
		GameState.load_game()
	get_tree().change_scene_to_file("res://scenes/WorldMap.tscn")


func _on_reset_pressed(i: int) -> void:
	pending_reset_slot = i
	reset_confirm.dialog_text = (
		"Erase everything saved in Slot %d? This can't be undone." % (i + 1)
	)
	reset_confirm.popup_centered()


func _on_reset_confirmed() -> void:
	if pending_reset_slot < 0:
		return
	var slot := pending_reset_slot
	pending_reset_slot = -1
	GameState.delete_slot(slot)
	if GameState.current_slot == slot:
		GameState.reset_progress()
	_refresh_slots()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/StartPlayingMenu.tscn")

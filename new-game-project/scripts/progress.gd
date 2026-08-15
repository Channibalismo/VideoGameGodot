extends Control
## Progress screen: view detailed lesson-by-lesson progress for any save
## slot, without needing to load into it. Read-only — uses GameState.peek_slot
## so it never disturbs whatever's actually loaded in a live session.

const NUM_SLOTS := GameState.NUM_SAVE_SLOTS
const NUM_LESSONS := GameState.TOTAL_LESSONS

@onready var back_button: Button = $BackButton
@onready var summary_label: Label = $Summary
@onready var lesson_grid: GridContainer = $LessonGrid

var slot_tabs: Array = []
var lesson_labels: Array = []
var selected_slot: int = 0


func _ready() -> void:
	for i in range(NUM_SLOTS):
		var tab: Button = get_node("SlotTabs/Slot%dTab" % (i + 1))
		slot_tabs.append(tab)
		tab.pressed.connect(_on_slot_tab_pressed.bind(i))

	for i in range(NUM_LESSONS):
		lesson_labels.append(lesson_grid.get_child(i))

	back_button.pressed.connect(_on_back_pressed)

	selected_slot = GameState.current_slot
	_refresh()


func _on_slot_tab_pressed(i: int) -> void:
	selected_slot = i
	_refresh()


func _refresh() -> void:
	for i in range(NUM_SLOTS):
		slot_tabs[i].disabled = (i == selected_slot)

	var data := GameState.peek_slot(selected_slot)

	if data.is_empty():
		summary_label.text = "SLOT %d has no progress yet." % (selected_slot + 1)
		for i in range(NUM_LESSONS):
			var n := i + 1
			_paint_lesson_label(lesson_labels[i], n, "locked")
		return

	var completed: Array = []
	for n in data.get("completed_lessons", []):
		completed.append(int(n))
	var xp: int = data.get("xp", 0)
	var coins: int = data.get("coins", 0)
	var pct := 0.0
	if NUM_LESSONS > 0:
		pct = 100.0 * float(completed.size()) / float(NUM_LESSONS)

	summary_label.text = "SLOT %d  —  %d XP  •  %d coins  •  %d/%d lessons complete (%d%%)" % [
		selected_slot + 1, xp, coins, completed.size(), NUM_LESSONS, int(round(pct))
	]

	for i in range(NUM_LESSONS):
		var n := i + 1
		var state := "locked"
		if completed.has(n):
			state = "completed"
		elif n <= 1 or completed.has(n - 1):
			state = "unlocked"
		_paint_lesson_label(lesson_labels[i], n, state)


func _paint_lesson_label(label: Label, lesson_number: int, state: String) -> void:
	match state:
		"completed":
			label.text = "✔ Lesson %d" % lesson_number
			label.modulate = Color(0.4, 0.85, 0.45)
		"unlocked":
			label.text = "● Lesson %d" % lesson_number
			label.modulate = Color(1.0, 0.82, 0.25)
		_:
			label.text = "🔒 Lesson %d" % lesson_number
			label.modulate = Color(0.55, 0.55, 0.6)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

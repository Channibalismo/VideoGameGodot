extends Control
## Coding Challenges — pick a lesson topic and a difficulty, then type the
## Java code that satisfies the objective. Grading strips all whitespace
## before comparing, so formatting/line-break differences don't matter.

@onready var lesson_option: OptionButton = $Layout/TopRow/LessonOption
@onready var easy_button: Button = $Layout/TopRow/DifficultyRow/EasyButton
@onready var medium_button: Button = $Layout/TopRow/DifficultyRow/MediumButton
@onready var hard_button: Button = $Layout/TopRow/DifficultyRow/HardButton
@onready var objective_label: RichTextLabel = $Layout/ObjectivePanel/ObjectiveLabel
@onready var code_input: TextEdit = $Layout/CodeInput
@onready var feedback_label: Label = $Layout/FeedbackLabel
@onready var submit_button: Button = $Layout/ButtonRow/SubmitButton
@onready var hint_button: Button = $Layout/ButtonRow/HintButton
@onready var back_button: Button = $Layout/ButtonRow/BackButton

var selected_lesson: int = 1
var selected_difficulty: String = "easy"
var difficulty_buttons: Dictionary = {}


func _ready() -> void:
	difficulty_buttons = {
		"easy": easy_button,
		"medium": medium_button,
		"hard": hard_button,
	}

	for lesson_name in ChallengeData.LESSON_NAMES:
		lesson_option.add_item(lesson_name)
	lesson_option.item_selected.connect(_on_lesson_selected)

	easy_button.pressed.connect(_on_difficulty_pressed.bind("easy"))
	medium_button.pressed.connect(_on_difficulty_pressed.bind("medium"))
	hard_button.pressed.connect(_on_difficulty_pressed.bind("hard"))

	submit_button.pressed.connect(_on_submit_pressed)
	hint_button.pressed.connect(_on_hint_pressed)
	back_button.pressed.connect(_on_back_pressed)

	_update_difficulty_highlight()
	_load_challenge()


func _on_lesson_selected(index: int) -> void:
	selected_lesson = index + 1
	_load_challenge()


func _on_difficulty_pressed(difficulty: String) -> void:
	selected_difficulty = difficulty
	_update_difficulty_highlight()
	_load_challenge()


func _update_difficulty_highlight() -> void:
	for key in difficulty_buttons:
		var btn: Button = difficulty_buttons[key]
		btn.modulate = Color(1, 1, 1) if key == selected_difficulty else Color(0.55, 0.55, 0.55)


func _current_challenge() -> Dictionary:
	return ChallengeData.CHALLENGES[selected_lesson][selected_difficulty]


func _load_challenge() -> void:
	var challenge := _current_challenge()
	objective_label.text = "[b]Objective:[/b] %s" % challenge["objective"]
	code_input.text = ""
	feedback_label.text = ""


func _normalize(code: String) -> String:
	return code.replace(" ", "").replace("\t", "").replace("\n", "").replace("\r", "")


func _on_submit_pressed() -> void:
	var challenge := _current_challenge()
	var submitted := _normalize(code_input.text)
	var expected := _normalize(challenge["answer"])

	if submitted == expected:
		feedback_label.text = "✔ Correct!"
		feedback_label.modulate = Color(0.4, 0.9, 0.4)
	else:
		feedback_label.text = "✘ Not quite — check your syntax and try again."
		feedback_label.modulate = Color(1.0, 0.4, 0.4)


func _on_hint_pressed() -> void:
	var challenge := _current_challenge()
	feedback_label.text = "Hint: %s" % challenge["answer"]
	feedback_label.modulate = Color(0.9, 0.85, 0.3)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

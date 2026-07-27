extends Node
## Autoload singleton tracking lesson progress, XP, and coins.
## Access anywhere as `GameState`.

signal lesson_completed(lesson_number: int)
signal xp_changed(new_xp: int)
signal coins_changed(new_coins: int)

const TOTAL_LESSONS := 9
const SAVE_PATH := "user://savegame.json"

var completed_lessons: Array[int] = []
var xp: int = 0
var coins: int = 0

func _ready() -> void:
	load_game()

## A lesson is unlocked if it's lesson 1, or the previous lesson is completed.
func is_unlocked(lesson_number: int) -> bool:
	if lesson_number <= 1:
		return true
	return completed_lessons.has(lesson_number - 1)

func is_completed(lesson_number: int) -> bool:
	return completed_lessons.has(lesson_number)

## The next lesson the player should play (first incomplete unlocked lesson).
func get_current_lesson() -> int:
	for i in range(1, TOTAL_LESSONS + 1):
		if not is_completed(i):
			return i
	return TOTAL_LESSONS

func complete_lesson(lesson_number: int, xp_reward: int = 20, coin_reward: int = 10) -> void:
	if not completed_lessons.has(lesson_number):
		completed_lessons.append(lesson_number)
		add_xp(xp_reward)
		add_coins(coin_reward)
		lesson_completed.emit(lesson_number)
		save_game()

func add_xp(amount: int) -> void:
	xp += amount
	xp_changed.emit(xp)

func add_coins(amount: int) -> void:
	coins += amount
	coins_changed.emit(coins)

func save_game() -> void:
	var data := {
		"completed_lessons": completed_lessons,
		"xp": xp,
		"coins": coins,
	}
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data))
		f.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not f:
		return
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var loaded_lessons: Array[int] = []
	for n in parsed.get("completed_lessons", []):
		loaded_lessons.append(int(n))
	completed_lessons = loaded_lessons
	xp = int(parsed.get("xp", 0))
	coins = int(parsed.get("coins", 0))

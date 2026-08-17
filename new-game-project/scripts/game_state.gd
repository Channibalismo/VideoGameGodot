extends Node
## Autoload singleton tracking lesson progress, XP, and coins.
## Access anywhere as `GameState`. Supports multiple save slots — call
## select_slot(n) (or just set current_slot) before save_game()/load_game()
## to target a specific slot. peek_slot(n) reads a slot's data without
## disturbing whatever's currently loaded, for slot-picker previews.

signal lesson_completed(lesson_number: int)
signal xp_changed(new_xp: int)
signal coins_changed(new_coins: int)

const TOTAL_LESSONS := 14
const NUM_SAVE_SLOTS := 3

var current_slot: int = 0
var completed_lessons: Array[int] = []
var xp: int = 0
var coins: int = 0


func _ready() -> void:
	load_game()


static func slot_path(slot: int) -> String:
	return "user://save_slot_%d.json" % slot


func slot_exists(slot: int) -> bool:
	return FileAccess.file_exists(slot_path(slot))


## Reads a slot's saved data straight from disk without touching the
## currently active slot. Returns {} if that slot has no save yet.
func peek_slot(slot: int) -> Dictionary:
	var path := slot_path(slot)
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if not f:
		return {}
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed


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

## Resets in-memory progress (does not touch disk until save_game() is called).
func reset_progress() -> void:
	completed_lessons = []
	xp = 0
	coins = 0

## Deletes a slot's save file entirely, so it reads back as empty.
func delete_slot(slot: int) -> void:
	var path := slot_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func save_game() -> void:
	var data := {
		"completed_lessons": completed_lessons,
		"xp": xp,
		"coins": coins,
	}
	var f := FileAccess.open(slot_path(current_slot), FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data))
		f.close()

func load_game() -> void:
	var parsed := peek_slot(current_slot)
	if parsed.is_empty():
		return
	var loaded_lessons: Array[int] = []
	for n in parsed.get("completed_lessons", []):
		loaded_lessons.append(int(n))
	completed_lessons = loaded_lessons
	xp = int(parsed.get("xp", 0))
	coins = int(parsed.get("coins", 0))

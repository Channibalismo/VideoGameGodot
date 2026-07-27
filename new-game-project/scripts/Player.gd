extends Resource
class_name Player

@export var username: String = "Beta"
@export var level: int = 1
@export var xp: int = 0

@export var completed_lessons : Array[String] = []
@export var achievements : Array[String] = []

func add_xp(amount:int):

	xp += amount

	while xp >= level * 100:
		xp -= level * 100
		level += 1

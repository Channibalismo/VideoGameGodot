class_name Achievement
extends Resource

@export var title = ""
@export var description = ""
@export var unlocked = false

func unlock():
	unlocked = true

const Player = preload("res://scripts/Player.gd")

func save_player(player):

	ResourceSaver.save(player, "user://player.tres")

func load_player():

	if ResourceLoader.exists("user://player.tres"):
		return load("user://player.tres")

	return Player.new()

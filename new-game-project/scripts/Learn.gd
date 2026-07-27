extends Node2D

var player = Player.new()

func level_up():
	player.level += 1
	$CanvasLayer/LevelUpPanel.show_level(player.level)

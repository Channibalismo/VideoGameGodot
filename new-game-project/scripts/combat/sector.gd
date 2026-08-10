extends Node2D
## Combat sector: patrol/chase glitch enemies, one touch and you're dead.
## Clear every enemy to win. Death triggers a fast Hotline-Miami-style
## restart of the whole room — no health bar, no mercy.

@onready var player: CharacterBody2D = $TrainingPlayer
@onready var hud: Control = $UI/CompilerHUD
@onready var loaded_label: Label = $UI/LoadedLabel
@onready var back_button: Button = $UI/BackButton
@onready var banner: Label = $UI/Banner

var enemies_remaining := 0


func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	hud.token_loaded.connect(_on_token_loaded)
	player.player_died.connect(_on_player_died)
	banner.visible = false

	var enemies := get_tree().get_nodes_in_group("enemies")
	enemies_remaining = enemies.size()
	for e in enemies:
		e.neutralized_changed.connect(_on_enemy_neutralized)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reload") and not hud.visible and not player.is_dead:
		hud.open()


func _on_token_loaded(token: String) -> void:
	player.loaded_token = token
	loaded_label.text = "LOADED: %s" % token


func _on_enemy_neutralized(_is_neutralized: bool) -> void:
	enemies_remaining -= 1
	if enemies_remaining <= 0:
		_show_banner("SECTOR CLEARED", Color(0.35, 1.0, 0.45))


func _on_player_died() -> void:
	_show_banner("TERMINATED", Color(1.0, 0.3, 0.3))
	await get_tree().create_timer(0.9).timeout
	get_tree().reload_current_scene()


func _show_banner(text: String, color: Color) -> void:
	banner.text = text
	banner.modulate = color
	banner.visible = true


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

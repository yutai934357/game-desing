extends Node2D

var cooldown = 1.0

func _ready():
	$PlayAgainButton.pressed.connect(_on_play_again)
	$MainMenuButton.pressed.connect(_on_main_menu)

func _on_play_again():
	get_tree().change_scene_to_file("res://GameScene.tscn")

func _on_main_menu():
	get_tree().change_scene_to_file("res://start_screen.tscn")

func _process(delta):
	cooldown -= delta
	if cooldown <= 0:
		if Input.is_joy_button_pressed(0, JOY_BUTTON_A) or Input.is_key_pressed(KEY_SPACE):
			get_tree().change_scene_to_file("res://GameScene.tscn")
		if Input.is_joy_button_pressed(0, JOY_BUTTON_B) or Input.is_key_pressed(KEY_ESCAPE):
			get_tree().change_scene_to_file("res://start_screen.tscn")

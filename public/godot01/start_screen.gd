extends Node2D

var button_cooldown = 0.3

func _ready():
	$StartButton.pressed.connect(_on_start_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://GameScene.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _process(delta):
	if button_cooldown > 0:
		button_cooldown -= delta
		return
	if Input.is_joy_button_pressed(0, JOY_BUTTON_A) or Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene_to_file("res://GameScene.tscn")
	if Input.is_joy_button_pressed(0, JOY_BUTTON_B) or Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

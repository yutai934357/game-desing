extends Node2D

var cooldown = 1.0
var http_request

func _ready():
	$PlayAgainButton.pressed.connect(_on_play_again)
	$MainMenuButton.pressed.connect(_on_main_menu)
	
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_rank_received)
	
	var url = "http://localhost:3000/rank"
	http_request.request(url, [], HTTPClient.METHOD_GET)

func _on_rank_received(result, response_code, headers, body):
	print("排行榜回應碼: ", response_code)
	print("排行榜內容: ", body.get_string_from_utf8())
	var json = JSON.parse_string(body.get_string_from_utf8())
	var text = "排行榜\n"
	if json != null:
		for i in range(json.size()):
			text += str(i+1) + ". " + str(json[i].get("user", "")) + " - " + str(json[i].get("score", 0)) + "分\n"
	$RankLabel.text = text
	print("設定的文字: ", text)

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

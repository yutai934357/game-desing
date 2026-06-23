extends Node2D

const CLOUD_SCENE = preload("res://cloud.tscn")
const DARK_CLOUD_SCENE = preload("res://dark_cloud.tscn")
const METEOR_SCENE = preload("res://meteor.tscn")
var spawn_timer = 0.0
var spawn_interval = 1.2
var last_cloud_y = 0.0
var last_cloud_x = 400.0
var player_node
var is_paused = false
var button_cooldown = 0.0
var score = 0
var meteor_timer = 0.0
var meteor_interval = 5.0
var http_request


func upload_score():
	
	var url = "http://localhost:3000/postscore"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({"score": score, "user": "player1"})
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(url, headers, HTTPClient.METHOD_POST, body)

func _on_request_completed(result, response_code, headers, body):
	print("回應碼: ", response_code)
	print("回應內容: ", body.get_string_from_utf8())
	get_tree().change_scene_to_file("res://win_screen.tscn")
	
	
func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	player_node = get_node("Player")
	# 從玩家位置稍微上方開始生成雲
	last_cloud_y = player_node.position.y - 50
	# 遊戲開始時先生成10朵雲
	for i in range(10):
		spawn_cloud()
	$PauseMenu.visible = false
	$PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_score()

func update_score():
	$HUD/ScoreLabel.text = "score: " + str(score)
	if score >= 10:
		upload_score()
		

func add_score(points):
	score += points
	if score < 0:
		score = 0
	update_score()

func reset_score():
	score = 0
	update_score()

func _process(delta):
	var bg = get_node("Background")
	bg.position.y = 324 + player_node.position.y * 0.2
	
	if button_cooldown > 0:
		button_cooldown -= delta
		return
	
	if is_paused:
		if Input.is_joy_button_pressed(0, JOY_BUTTON_A) or Input.is_key_pressed(KEY_SPACE):
			is_paused = false
			get_tree().paused = false
			$PauseMenu.visible = false
			button_cooldown = 0.3
		elif Input.is_joy_button_pressed(0, JOY_BUTTON_B) or Input.is_key_pressed(KEY_ESCAPE):
			get_tree().paused = false
			button_cooldown = 0.3
			get_tree().change_scene_to_file("res://start_screen.tscn")
		elif Input.is_joy_button_pressed(0, JOY_BUTTON_X) or Input.is_key_pressed(KEY_Q):
			get_tree().quit()
		return
	
	if Input.is_joy_button_pressed(0, JOY_BUTTON_START) or Input.is_key_pressed(KEY_ENTER):
		is_paused = true
		get_tree().paused = true
		$PauseMenu.visible = true
		button_cooldown = 0.3
	
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_cloud()
	
	meteor_timer += delta
	if meteor_timer >= meteor_interval:
		meteor_timer = 0.0
		spawn_meteor()

func spawn_cloud():
	var new_y = last_cloud_y - randf_range(100, 150)
	# 如果雲的位置比玩家高度還低，強制往上生成
	if new_y > player_node.position.y - 300:
		new_y = player_node.position.y - randf_range(300, 500)
	var cloud_count = randi_range(2, 3)
	for i in range(cloud_count):
		var new_x = randf_range(80, 870)
		var offset_y = randf_range(-30, 30)
		var cloud = CLOUD_SCENE.instantiate()
		cloud.position = Vector2(new_x, new_y + offset_y)
		add_child(cloud)
	last_cloud_y = new_y
	last_cloud_x = randf_range(80, 870)
	if randf() < 0.5:
		var dark = DARK_CLOUD_SCENE.instantiate()
		dark.position = Vector2(randf_range(80, 870), new_y - randf_range(50, 100))
		add_child(dark)
		
func spawn_meteor():
	var meteor = METEOR_SCENE.instantiate()
	meteor.position = Vector2(
		randf_range(600, 1000),
		player_node.position.y - 400
	)
	add_child(meteor)

extends CharacterBody2D

const SPEED = 300.0
const GRAVITY = 1200.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	var axis = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	
	if axis > 0.2 or Input.is_key_pressed(KEY_RIGHT):
		velocity.x = SPEED
	elif axis < -0.2 or Input.is_key_pressed(KEY_LEFT):
		velocity.x = -SPEED
	else:
		if not is_on_floor():
			velocity.x += axis * 20
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if (Input.is_joy_button_pressed(0, JOY_BUTTON_A) or Input.is_key_pressed(KEY_SPACE)) and is_on_floor():
		velocity.y = -800.0
	
	move_and_slide()
	
	if global_position.x < 50:
		global_position.x = 50
		velocity.x = 0
	if global_position.x > 1600:
		global_position.x = 1600
		velocity.x = 0
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i)
		var body = collider.get_collider()
		
		if body.is_in_group("cloud") and velocity.y >= 0:
			var diff_x = global_position.x - body.global_position.x
			if diff_x < -40:
				velocity = Vector2(-400, -850)
			elif diff_x > 40:
				velocity = Vector2(400, -850)
			else:
				velocity = Vector2(0, -850)
			Input.start_joy_vibration(0, 0.5, 0.5, 0.2)
			body.queue_free()
			get_node("/root/GameScene").add_score(5)
			break
		
		if body.name == "DarkCloud" and velocity.y >= 0:
			Input.start_joy_vibration(0, 1.0, 1.0, 0.8)
			body.queue_free()
			get_node("/root/GameScene").add_score(-20)
			break
		
		if body.is_in_group("meteor"):
			Input.start_joy_vibration(0, 1.0, 1.0, 0.5)
			get_node("/root/GameScene").reset_score()
			body.queue_free()
			break

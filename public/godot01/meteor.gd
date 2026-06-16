extends RigidBody2D

var direction = Vector2(-1, 1).normalized()
var speed = 1500.0

func _ready():
	gravity_scale = 5.0
	linear_velocity = direction * speed
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	queue_free()

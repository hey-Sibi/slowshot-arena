extends Area2D

var direction = Vector2.ZERO
var speed = 500

func _process(delta):
	position += direction * speed * delta

func set_direction(dir):
	direction = dir

func _on_body_entered(body):
	if body.is_in_group("nemico"):
		body.take_damage(1)
		queue_free()

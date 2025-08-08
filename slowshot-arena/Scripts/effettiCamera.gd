extends Camera2D

@export var shake_amount = 2.0
@export var shake_duration = 0.05
var shake_timer = 0.0
var original_position = Vector2.ZERO

func _ready():
	original_position = position

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		var offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		position = original_position + offset
	else:
		position = original_position

func start_shake(duration, amount):
	shake_duration = duration
	shake_amount = amount
	shake_timer = shake_duration

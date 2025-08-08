extends AnimatedSprite2D

func play_hit():
	stop()
	frame = 0
	visible = true
	play("hit")

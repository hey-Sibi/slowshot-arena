extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval = 3.0

var timer = 0.0

func _process(delta):
	timer -= delta
	if timer <= 0:
		spawn_enemy()
		timer = spawn_interval

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	# Posizione spawn casuale nell'arena (esempio 800x600)
	enemy.position = Vector2(randi() % 800, randi() % 600)

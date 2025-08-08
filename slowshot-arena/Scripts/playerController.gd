extends CharacterBody2D

#Proprietà player
@export var speed: float = 300.0
@onready var animated_sprite: AnimatedSprite2D = $corpo/gambe

#Arma
@onready var weapon_pivot: Node2D = $pivotArma
@onready var weapon_sprite: Sprite2D = $pivotArma/arma
@onready var shoot_pos: Marker2D = $pivotArma/canna

#Proiettile
@export var projectile_scene: PackedScene
@export var projectile_speed = 500


func _ready():
	print("Player inizializzato")

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot_projectile()

func _physics_process(delta):
	handle_movement()
	handle_rotation()
	move_and_slide()

func handle_movement():
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
		if not animated_sprite.is_playing():
			animated_sprite.play("cammina")
	else:
		velocity = Vector2.ZERO
		if animated_sprite.is_playing():
			animated_sprite.stop()
			animated_sprite.frame = 0

func handle_rotation():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	var offset = deg_to_rad(-89.5)
	rotation = direction.angle() + offset

func shoot_projectile():
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = shoot_pos.global_position
	
	# Calcola direzione dalla posizione giocatore verso il mouse
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()

	projectile.set_direction(direction)
	projectile.speed = projectile_speed

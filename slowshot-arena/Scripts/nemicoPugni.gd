extends CharacterBody2D
#rimuovere attackArea
@export var max_health := 10
var health = max_health

@export var speed: float = 100.0
@export var rotation_offset_deg: float = 0.0  # in gradi

var player: Node2D = null
var player_in_range: bool = false

@onready var anim: AnimationPlayer = $animazionePugno
@onready var attack_timer: Timer = $attackTimer
@onready var body_sprite: AnimatedSprite2D = $corpo/gambe
@onready var hit : AnimatedSprite2D = $corpo/hit
#@onready var raycast = $RayCast2D
@onready var health_bar = $vita
@onready var attack_area = $attackArea

func _ready():
	# Cerca il player nel gruppo
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

	# Inizializza la barra vita
	health_bar.max_value = max_health
	health_bar.value = health

	# Collega segnali per entrata/uscita dalla zona di attacco
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)

func _physics_process(delta):
	if player == null or not is_instance_valid(player):
		return

	var to_player = player.global_position - global_position

	# Ruota verso il player
	rotation = to_player.angle() + deg_to_rad(rotation_offset_deg)

	"""#Aggiorna raycast verso il player (lunghezza 20)
	raycast.target_position = to_player.normalized() * 20.0
	raycast.force_raycast_update()

	if raycast.is_colliding():
		# Ostacolo davanti: fermati completamente
		velocity = Vector2.ZERO
		anim.stop()
		if body_sprite.is_playing():
			body_sprite.stop()
			body_sprite.frame = 0
		attack_timer.stop()
		return"""

	if not player_in_range:
		velocity = to_player.normalized() * speed
		anim.stop()
		if not body_sprite.is_playing():
			body_sprite.play("cammina")
		attack_timer.stop()
	else:
		velocity = Vector2.ZERO
		if not anim.is_playing():
			anim.play("pugno")
		if body_sprite.is_playing():
			body_sprite.stop()
			body_sprite.frame = 0
		if attack_timer.is_stopped():
			attack_timer.start()

	move_and_slide()

func _on_AttackTimer_timeout():
	hit.play_hit()

	if not is_instance_valid(player):
		return

func take_damage(amount):
	health -= amount
	health = clamp(health, 0, max_health)
	health_bar.value = health

	if health <= 0:
		queue_free()

func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_attack_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

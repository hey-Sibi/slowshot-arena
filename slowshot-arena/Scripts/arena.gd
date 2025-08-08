extends Node2D

@export var arena_width: float = 1920
@export var arena_height: float = 1080
@export var num_obstacles: int = 10
@export var obstacle_size: Vector2 = Vector2(60, 60)

@onready var player: CharacterBody2D = $Player
@onready var walls: StaticBody2D = $Walls

func _ready():
	setup_arena()
	print("Arena inizializzata: ", arena_width, "x", arena_height)

func setup_arena():
	create_arena_walls()
	#spawn_obstacles()

func create_arena_walls():
	var wall_thickness = 50
	create_wall(Vector2(arena_width/2, -wall_thickness/2), Vector2(arena_width, wall_thickness))
	create_wall(Vector2(arena_width/2, arena_height + wall_thickness/2), Vector2(arena_width, wall_thickness))
	create_wall(Vector2(-wall_thickness/2, arena_height/2), Vector2(wall_thickness, arena_height))
	create_wall(Vector2(arena_width + wall_thickness/2, arena_height/2), Vector2(wall_thickness, arena_height))

func create_wall(pos: Vector2, size: Vector2):
	var wall_body = StaticBody2D.new()
	var collision_shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	var visual = ColorRect.new()

	rect_shape.size = size
	collision_shape.shape = rect_shape

	visual.size = size
	visual.color = Color.GRAY
	visual.position = -size / 2

	wall_body.add_child(collision_shape)
	wall_body.add_child(visual)
	wall_body.position = pos

	add_child(wall_body)


	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_bodies = true
	query.collide_with_areas = false
	var result = space_state.intersect_point(query)
	return result.size() == 0

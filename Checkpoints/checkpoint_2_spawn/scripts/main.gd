extends Node2D

@export var obstacle_scene: PackedScene
var rng = RandomNumberGenerator.new()
@onready var obstacle_layer = $ObstacleLayer
@onready var spawn_timer = $SpawnTimer


func _ready():
	rng.randomize()
	spawn_timer.wait_time = 0.8
	spawn_timer.timeout.connect(_spawn_obstacle)
	spawn_timer.start()


func _spawn_obstacle():
	var obstacle = obstacle_scene.instantiate()
	obstacle.position = Vector2(rng.randf_range(40.0, get_viewport_rect().size.x - 40.0), -60.0)
	obstacle_layer.add_child(obstacle)

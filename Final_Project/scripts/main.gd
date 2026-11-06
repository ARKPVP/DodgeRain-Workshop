extends Node2D

@export var obstacle_scene: PackedScene

var score: float = 0.0
var game_running: bool = true
var rng = RandomNumberGenerator.new()

@onready var player = $Player
@onready var obstacle_layer = $ObstacleLayer
@onready var spawn_timer = $SpawnTimer
@onready var score_label = $UI/ScoreLabel
@onready var message_label = $UI/MessageLabel
@onready var hit_sound = $HitSound


func _ready():
	rng.randomize()
	score_label.text = "Score: 0"
	message_label.text = ""
	spawn_timer.wait_time = 0.8
	spawn_timer.timeout.connect(_spawn_obstacle)
	spawn_timer.start()


func _process(delta):
	if game_running:
		score += delta
		score_label.text = "Score: %d" % int(score)
	elif Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func _spawn_obstacle():
	if not game_running:
		return
	var obstacle = obstacle_scene.instantiate()
	var screen_width = get_viewport_rect().size.x
	obstacle.position = Vector2(rng.randf_range(40.0, screen_width - 40.0), -60.0)
	obstacle.body_entered.connect(_on_obstacle_body_entered)
	obstacle_layer.add_child(obstacle)


func _on_obstacle_body_entered(body):
	if game_running and body == player:
		game_over()


func game_over():
	if not game_running:
		return
	game_running = false
	spawn_timer.stop()
	player.set_physics_process(false)
	for obstacle in obstacle_layer.get_children():
		obstacle.set_process(false)
	message_label.text = (
		"GAME OVER\n"
		+ "Score: %d\n" % int(score)
		+ "Press R / Enter to Restart"
	)
	if hit_sound.stream:
		hit_sound.play()

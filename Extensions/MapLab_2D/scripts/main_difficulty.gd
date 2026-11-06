extends "res://scripts/main.gd"


func _spawn_obstacle():
	if not game_running:
		return
	var level = int(score / 15.0)
	spawn_timer.wait_time = maxf(0.25, 0.8 - float(level) * 0.08)
	var obstacle = obstacle_scene.instantiate()
	obstacle.fall_speed = minf(600.0, 300.0 + float(level) * 30.0)
	var screen_width = get_viewport_rect().size.x
	obstacle.position = Vector2(rng.randf_range(40.0, screen_width - 40.0), -60.0)
	obstacle.body_entered.connect(_on_obstacle_body_entered)
	obstacle_layer.add_child(obstacle)

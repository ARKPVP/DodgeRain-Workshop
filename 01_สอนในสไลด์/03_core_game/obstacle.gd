extends Area2D

@export var fall_speed: float = 300.0


func _process(delta):
	position.y += fall_speed * delta
	if position.y > get_viewport_rect().size.y + 80.0:
		queue_free()

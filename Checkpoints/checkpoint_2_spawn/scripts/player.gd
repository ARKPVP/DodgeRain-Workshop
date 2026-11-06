extends CharacterBody2D

@export var speed: float = 500.0

var screen_size: Vector2


func _ready():
	screen_size = get_viewport_rect().size


func _physics_process(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	velocity.y = 0.0
	move_and_slide()
	position.x = clamp(position.x, 32.0, screen_size.x - 32.0)

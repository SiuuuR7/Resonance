extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
var last_direction = Vector2.DOWN
var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	
	var direction = Input.get_vector("move_left", "move_right","move_up", "move_down" ).normalized()
	velocity = direction * 225
	if not direction.is_equal_approx(Vector2.ZERO):
		last_direction = direction
		play_animation("running", direction)
	else:
		play_animation("idle", last_direction)
	move_and_slide()

func play_animation(prefix: String, direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		animated_sprite.flip_h = direction.x < 0
		animated_sprite.play(prefix + "_side")

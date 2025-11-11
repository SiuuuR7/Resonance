
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
var last_direction = Vector2.DOWN
var is_attacking: bool = false

var is_guitar_equipped = false

func _physics_process(delta: float) -> void:
	
	if is_guitar_equipped == true:
		Vector2.ZERO
		move_and_slide()
		return
	
	var direction = Input.get_vector("move_left", "move_right","move_up", "move_down" ).normalized()
	velocity = direction * 225
	if not direction.is_equal_approx(Vector2.ZERO):
		last_direction = direction
		play_animation("running", direction)
	else:
		play_animation("idle", last_direction)
		
	if Input.is_action_just_pressed("guitar_equip"):
		equip_guitar()
	else:
		unequip_guitar()
		

	move_and_slide()
	
func equip_guitar():
	if Input.is_action_just_pressed("guitar_equip"):
		is_guitar_equipped = true
		animated_sprite.play("guitar_equip")
func unequip_guitar():
	if is_guitar_equipped == true and Input.is_action_just_pressed("guitar_equip"):
		animated_sprite.play("guitar_unequip")
		is_guitar_equipped = false
		
func play_animation(prefix: String, direction: Vector2) -> void:
	if abs(direction.x) > 0 and abs(direction.y) > 0:
		if direction.y < 0:
			animated_sprite.flip_h = direction.x < 0
			animated_sprite.play(prefix + "_diag_up")
		else:
			animated_sprite.flip_h = direction.x < 0
			animated_sprite.play(prefix + "_side")
		return 
	
	if abs(direction.x) > abs(direction.y):
		animated_sprite.flip_h = direction.x < 0
		animated_sprite.play(prefix + "_side")
	elif direction.y > 0:
		animated_sprite.flip_h = false
		animated_sprite.play(prefix + "_back")
	else:
		animated_sprite.flip_h = false
		animated_sprite.play(prefix + "_front")

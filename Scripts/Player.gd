
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
var last_direction = Vector2.DOWN
var is_equipping = false
var is_unequipping = false
var is_strumming = false
var is_guitar_equipped = false

func _ready():
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	
	if is_equipping or is_unequipping or is_strumming:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var direction = Vector2.ZERO
	if not is_guitar_equipped:
		direction = Input.get_vector("move_left", "move_right","move_up", "move_down").normalized()
		velocity = direction * 80
	else:
		velocity = Vector2.ZERO
		
	if not direction.is_equal_approx(Vector2.ZERO):
		last_direction = direction
		if is_guitar_equipped:
			play_animation("guitar_running", direction)
		else:
			play_animation("running", direction)
	else:
		if is_guitar_equipped:
			play_animation("guitar_idle", last_direction)
		else:
			play_animation("idle", last_direction)
		
	if Input.is_action_just_pressed("guitar_equip"):
		if is_guitar_equipped:
			unequip_guitar()
		else:
			equip_guitar()
			
	if is_guitar_equipped and Input.is_action_just_pressed("guitar_strum"):
		strum_guitar()
		
		

	move_and_slide()
	
func equip_guitar():
	is_guitar_equipped = true
	is_equipping = true
	animated_sprite.play("guitar_equip")
func unequip_guitar():
	is_guitar_equipped = false
	is_unequipping = true
	animated_sprite.play("guitar_unequip")
	
func strum_guitar():
	is_strumming = true
	animated_sprite.play("guitar_strum")

func _on_animation_finished():
	if is_equipping:
		is_equipping = false
		animated_sprite.play("guitar_idle") # or whichever direction
	elif is_unequipping:
		is_unequipping = false
		animated_sprite.play("idle_side") # back to normal idle
	elif is_strumming:
		is_strumming = false
		animated_sprite.play("guitar_idle")  # Return to idle after strum
		
		
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

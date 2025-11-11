
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
var last_direction = Vector2.DOWN
var is_attacking: bool = false
var is_guitar_equipped = false
var is_playing_animation = false

func _ready() -> void:
	if not animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	
	if is_playing_animation:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	var direction = Input.get_vector("move_left", "move_right","move_up", "move_down" ).normalized()
	velocity = direction * 225
	if not direction.is_equal_approx(Vector2.ZERO):
		last_direction = direction
		play_animation("running", direction)
	else:
		play_animation("idle", last_direction)
	
	if not is_playing_animation:
		if Input.is_action_just_pressed("guitar_equip"):
			if not is_guitar_equipped:
				equip_guitar()
			else:
				unequip_guitar()
		elif Input.is_action_just_pressed("guitar_strum") and is_guitar_equipped:
			strum_guitar()
			
	move_and_slide()
	
func equip_guitar() -> void:
	is_playing_animation = true
	animated_sprite.play("guitar_equip")
	
func strum_guitar() -> void:
	is_playing_animation = true
	animated_sprite.play("guitar_strum")
	
func unequip_guitar() -> void:
	is_playing_animation = true
	animated_sprite.play("guitar_unequip")

func _on_animation_finished() -> void:
	var current_anim = animated_sprite.animation

	match current_anim:
		"guitar_equip":
			is_guitar_equipped = true
			animated_sprite.play("guitar_idle")
		"guitar_unequip":
			is_guitar_equipped = false
			animated_sprite.play("idle_side")
		"guitar_strum":
			animated_sprite.play("guitar_idle")

	is_playing_animation = false

func play_animation(prefix: String, direction: Vector2) -> void:
	
	if animated_sprite.animation.begins_with("guitar_"):
		return
	
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

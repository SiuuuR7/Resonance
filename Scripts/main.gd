extends Node2D

@onready var pause_menu: Control = $Disk/Camera2D2/Pause

var paused = false



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()


func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused

func _ready() -> void:
	Engine.time_scale = 1
	pause_menu.hide()
	paused = false

extends Control

@onready var main = get_node("/root/Main")

func _on_resume_pressed() -> void:
	main.pauseMenu()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")

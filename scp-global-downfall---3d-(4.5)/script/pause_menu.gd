extends Control

@onready var main = $".."

func _on_resume_pressed():
	main.pausemenu()


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://GUI/Intro.tscn")

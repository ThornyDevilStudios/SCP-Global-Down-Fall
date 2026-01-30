extends Control

func _on_play_pressed():
	GlobalVar.select_mode = ("play")
	get_tree().change_scene_to_file("res://GUI/In.tscn")
	
func _on_settings_pressed():
	GlobalVar.select_mode = ("settings")
	get_tree().change_scene_to_file("res://GUI/In.tscn")
	
func _on_credits_pressed():
	pass # Replace with function body.
	
func _on_quit_pressed():
	get_tree().quit()

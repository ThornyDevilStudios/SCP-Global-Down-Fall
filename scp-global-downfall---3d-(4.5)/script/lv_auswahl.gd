extends Control

func _on_test_map_pressed():
	GlobalVar.scene = ("test_map")
	get_tree().change_scene_to_file("res://GUI/loading_screen.tscn")

func _on_lv_1_pressed():
	GlobalVar.scene = ("lv_1")
	get_tree().change_scene_to_file("res://GUI/loading_screen.tscn")

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().change_scene_to_file("res://GUI/Out.tscn")

extends Control



func _on_check_box_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)

func _on_win_option_button_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().change_scene_to_file("res://GUI/Out.tscn")

func _on_res_option_button_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1366,768))
		1:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		2:
			DisplayServer.window_set_size(Vector2i(2560,1440))
		3:
			DisplayServer.window_set_size(Vector2i(3840,2160))

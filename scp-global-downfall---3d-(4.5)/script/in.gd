extends Control



func _on_video_stream_player_finished():
	if GlobalVar.select_mode == ("settings"):
		get_tree().change_scene_to_file("res://GUI/Settings.tscn")
	elif GlobalVar.select_mode == ("play"):
		get_tree().change_scene_to_file("res://GUI/lv_auswahl.tscn")

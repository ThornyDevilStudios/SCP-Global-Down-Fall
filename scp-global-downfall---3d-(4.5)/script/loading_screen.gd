extends Control

var test_map = "res://Worlds/-Test-.tscn"
var lv_1 = "res://Worlds/lv_1.tscn"
var next_scene = "debug"

func _ready():
	if GlobalVar.scene == ("test_map"):
		next_scene = test_map
	elif GlobalVar.scene == ("lv_1"):
		next_scene = lv_1
	ResourceLoader.load_threaded_request(next_scene)
	

func _process(delta):
	var progress = []
	ResourceLoader.load_threaded_get_status(next_scene, progress)
	$progress_bar.text = str(progress[0]*100)+"%"
	
	if progress[0] == 1:
		var packed_scene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(packed_scene)

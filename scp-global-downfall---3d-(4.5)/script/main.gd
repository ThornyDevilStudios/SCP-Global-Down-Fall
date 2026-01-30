extends Node3D

@onready var pause_menu = $pause_menu
var paused : bool = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pausemenu()
	
func pausemenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else: 
		pause_menu.show()
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		
	paused = !paused

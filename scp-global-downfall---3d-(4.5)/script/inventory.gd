extends Control

@onready var inventory = $"."
var inventoryed : bool = false

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		inventory_menu()
	
func inventory_menu():
	if inventoryed:
		inventory.hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else: 
		inventory.show()
		Engine.time_scale = 0.2
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		
	inventoryed = !inventoryed

func _on_faust_pressed():
	inventory_menu()

func _on_piew_piew_pressed():
	inventory_menu()

func _on_haudrauf_pressed():
	inventory_menu()

func _on_noga_boga_pressed():
	inventory_menu()

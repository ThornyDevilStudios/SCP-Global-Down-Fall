extends Node3D

@onready var text = $TakedownBox/CanvasLayer/Label

func _on_takedown_box_area_entered(area):
	text.show()

func _on_takedown_box_area_exited(area):
	text.hide()

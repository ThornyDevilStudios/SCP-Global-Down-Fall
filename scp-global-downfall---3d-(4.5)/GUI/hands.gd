extends Control

@onready var idle = $idle
@onready var takedown1 = $takedown1

func _physics_process(delta):
	if GlobalVar.walking == true:
		idle.play()
	if GlobalVar.takedown1 == true:
		takedown1.play()

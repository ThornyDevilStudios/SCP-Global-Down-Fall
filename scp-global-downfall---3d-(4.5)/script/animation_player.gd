extends Node3D

@onready var ani_set = $ani_set
# Called when the node enters the scene tree for the first time.
func _ready():
	ani_set.play("Debug")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if GlobalVar.walking == true:
		ani_set.play("Walking")
	elif GlobalVar.walking == false:
		ani_set.play("Debug")
	
	if GlobalVar.sprinting == true:
		ani_set.speed_scale = 2
	elif GlobalVar.walking == false:
		ani_set.speed_scale = 1

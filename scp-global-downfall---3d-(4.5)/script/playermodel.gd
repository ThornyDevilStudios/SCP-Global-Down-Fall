extends Node3D

@export var offset_z : float = 0.05
@onready var ani_set = $HumanM_Walk01_Forward/AnimationPlayer
var original_z : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	ani_set.play("idle/Untitled")
	original_z = position.z
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if GlobalVar.sprinting == true and GlobalVar.walking == true:
		ani_set.play("run/Untitled")
		$".".position.z = original_z + offset_z
	elif GlobalVar.walking == false:
		$".".position.z = original_z
		ani_set.play("idle/Untitled")
	elif GlobalVar.walking == true:
		$".".position.z = original_z
		if GlobalVar.direction == ("forward"):
			ani_set.play("Untitled")
		elif GlobalVar.direction == ("left"):
			ani_set.play("left/Untitled")
		elif GlobalVar.direction == ("right"):
			ani_set.play("right/Untitled")
		elif GlobalVar.direction == ("backward"):
			ani_set.play("backward/Untitled")
		

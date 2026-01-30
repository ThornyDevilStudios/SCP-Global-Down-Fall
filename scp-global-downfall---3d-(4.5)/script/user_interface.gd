extends Control


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	$"HP-Amount".text = str(GlobalVar.hp / GlobalVar.key)

extends Node3D

@onready var ani_set = $"BasicMotions_DummyModel_M/NPC-Takeodwn1/AnimationPlayer"
@onready var marker = $BasicMotions_DummyModel_M/Marker3D
@onready var marker2 = $BasicMotions_DummyModel_M/Marker3D2
var cankill : bool = false

func _on_takedown_box_area_entered(area):
	cankill = true

func _on_takedown_box_area_exited(area):
	cankill = false

func _physics_process(delta):
	if cankill and Input.is_action_just_pressed("takedown"):
		# Spielerposition setzen
		GlobalVar.takedown_cords = marker.global_transform.origin
		GlobalVar.takedown_dir = marker2.global_transform.origin
		# Blickrichtung relativ berechnen
		#var look_dir = (marker2.global_transform.origin - marker.global_transform.origin).normalized()
		#GlobalVar.takedown_dir = GlobalVar.takedown_cords + look_dir * 1.0
		
		# Takedown Animation
		ani_set.play("B-hipsAction")
		await ani_set.animation_finished
		ani_set.play("GLTF_created_0Action")
		
		# Daten zurücksetzen
		GlobalVar.takedown_cords = Vector3.ZERO
		GlobalVar.takedown_dir = Vector3.ZERO

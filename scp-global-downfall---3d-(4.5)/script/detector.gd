extends CharacterBody3D

var speed = 2
var accel = 10
var start_pos: Vector3 = Vector3.ZERO
var player_detected = false
var has_seen_player = false   # merkt sich, ob Spieler jemals gesehen wurde

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var ani_set: AnimationPlayer = $HumanM_Walk01_Forward/BasicMotions_DummyModel_M2/AnimationPlayer
@onready var vision_area = $VisionArea
@onready var vision_raycast = $VisionRaycast
@onready var not_see: Timer = $not_see   # Timer aus deiner Szene

func _ready():
	print("NPC ready. Startpos:", global_position)
	start_pos = global_position
	not_see.one_shot = true
	not_see.wait_time = 5.0   # Sekunden bis „vergessen“
	not_see.timeout.connect(_on_not_see_timeout)

func _process(delta):
	if player_detected:
		has_seen_player = true
		# Spieler verfolgen
		nav.target_position = GlobalVar.player_position
		var direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, accel * delta)
		GlobalVar.player_position.y = global_transform.origin.y
		look_at(GlobalVar.player_position, Vector3.UP)
		move_and_slide()
	else:
		# Nur zurücklaufen, wenn er schon mal Spieler gesehen hat
		if has_seen_player:
			var dist = global_position.distance_to(start_pos)
			if dist > 0.5:
				nav.target_position = start_pos
				var direction = (nav.get_next_path_position() - global_position).normalized()
				velocity = velocity.lerp(direction * speed, accel * delta)
				look_at(start_pos, Vector3.UP)
				move_and_slide()
			else:
				velocity = Vector3.ZERO
				move_and_slide()
		else:
			# Anfangszustand: komplett stillstehen
			velocity = Vector3.ZERO
			move_and_slide()

	# Vision-Check immer am Ende
	_check_vision()

func _check_vision():
	vision_raycast.debug_shape_custom_color = Color(0, 1, 0)  # Grün
	var overlaps = vision_area.get_overlapping_bodies()

	for overlap in overlaps:
		if overlap.name == "CharacterBody3D" or overlap.name == "-naked_body-":
			var player_position = overlap.global_transform.origin
			vision_raycast.target_position = vision_raycast.to_local(player_position)
			vision_raycast.force_raycast_update()

			if vision_raycast.is_colliding():
				var collider = vision_raycast.get_collider()
				if collider.name == "CharacterBody3D" or collider.name == "-naked_body-":
					player_detected = true
					vision_raycast.debug_shape_custom_color = Color(1, 0, 0)  # Rot
					not_see.start()   # Timer jedes Mal neu starten
					return

	# kein sofortiges "false" → Timer entscheidet

func _on_not_see_timeout():
	player_detected = false
	print(">>> Spieler vergessen nach", not_see.wait_time, "Sekunden <<<")

func _physics_process(delta):
	if not ani_set.is_playing():
		ani_set.play("Untitled")

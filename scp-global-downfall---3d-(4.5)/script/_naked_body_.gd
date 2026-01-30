extends CharacterBody3D

@export var SPEED_DEFAULT : float = 5.0
@export var SPEED_CROUCH : float = 2.0
@export var JUMP_VELOCITY : float = 4.5
@export var MOUSE_SENSITIVITY : float = 0.5
@export var TILT_LOWER_LIMIT := deg_to_rad(-50.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Camera3D
@export var ANIMATIONPLAYER : AnimationPlayer
@export var CROUCH_SHAPECAST : Node3D

@onready var footsteps = $AudioStreamPlayer
@onready var ani_hands_idle = $"CameraController/Camera3D/Player-Hand-Idle/AnimationPlayer"
@onready var hand_idle = $"CameraController/Camera3D/Player-Hand-Idle"
@onready var ani_hands_takedown1 = $"CameraController/Camera3D/Player-Takeodwn1/AnimationPlayer"
@onready var hand_takedown1 = $"CameraController/Camera3D/Player-Takeodwn1"

var _walking : bool = false
var _speed : float = SPEED_DEFAULT
var _rotation_input : float = 0.0
var _tilt_input : float = 0.0
var _mouse_rotation : Vector3 = Vector3.ZERO
var _player_rotation : Vector3 = Vector3.ZERO
var _camera_rotation : Vector3 = Vector3.ZERO
var _is_crouching : bool = false
var use_camera : bool = true
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$ShapeCast3D.add_exception(self)

func _unhandled_input(event: InputEvent) -> void:
	if use_camera:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
			_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("run") and not _is_crouching:
		_speed = 6
		GlobalVar.sprinting = true
	elif event.is_action_released("run") or _is_crouching:
		_speed = SPEED_DEFAULT
		GlobalVar.sprinting = false

func _update_camera(delta):
	if use_camera:
		_mouse_rotation.x += _tilt_input * delta
		_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
		_mouse_rotation.y += _rotation_input * delta

		_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)
		_camera_rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)

		global_transform.basis = Basis.from_euler(_player_rotation)
		CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)

		CAMERA_CONTROLLER.rotation.z = 0.0

		_rotation_input = 0.0
		_tilt_input = 0.0

func _physics_process(delta):
	_update_camera(delta)
	GlobalVar.player_position = position

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not _is_crouching:
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * _speed
		velocity.z = direction.z * _speed
		_walking = true
		GlobalVar.walking = true
		ani_hands_idle.play("GLTF_created_0Action")
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		velocity.z = move_toward(velocity.z, 0, _speed)
		_walking = false
		GlobalVar.walking = false
		ani_hands_idle.play("GLTF_created_0Action")

	if _walking and is_on_floor():
		if not footsteps.is_playing():
			footsteps.pitch_scale = randf_range(0.8, 1.2)
			footsteps.play()
	else:
		footsteps.stop()

	move_and_slide()

	if GlobalVar.takedown_cords != Vector3.ZERO:
		takedown(delta)

func takedown(delta):
	# Spielerposition auf Marker1
	global_transform.origin = GlobalVar.takedown_cords
	if GlobalVar.takedown_dir != null:
		var direction = (GlobalVar.takedown_dir - global_transform.origin).normalized()
		if direction.length() > 0:
			var target_basis = Basis().looking_at(direction, Vector3.UP)
			CAMERA_CONTROLLER.global_transform.basis = target_basis

	# Player horizontal rotation
	#var dir = GlobalVar.takedown_dir - global_transform.origin
	#dir.y = 0
	#if dir.length() > 0:
	#	dir = dir.normalized()
	#	rotation.y = atan2(dir.x, dir.z)

	# Kamera auf Marker2 schauen, horizontal fixiert
	#var camera_target = Vector3(
		#GlobalVar.takedown_dir.x,
		#CAMERA_CONTROLLER.global_transform.origin.y,
		#GlobalVar.takedown_dir.z
	#)
	#var target_basis = Basis().looking_at(camera_target - CAMERA_CONTROLLER.global_transform.origin, Vector3.UP)
	#CAMERA_CONTROLLER.transform.basis = CAMERA_CONTROLLER.transform.basis.slerp(target_basis, delta * 5.0)
	#_camera_rotation = target_basis.get_euler()

	# Handanimationen
	use_camera = false
	hand_idle.hide()
	hand_takedown1.show()
	ani_hands_takedown1.play("GLTF_created_0Action")
	await ani_hands_takedown1.animation_finished
	use_camera = true
	hand_idle.show()
	hand_takedown1.hide()

func toggle_crouch():
	if _is_crouching and not CROUCH_SHAPECAST.is_colliding():
		ANIMATIONPLAYER.play("Crouch", -1, -SPEED_CROUCH, true)
		_speed = SPEED_DEFAULT
	elif not _is_crouching:
		ANIMATIONPLAYER.play("Crouch", -1, SPEED_CROUCH)
		_speed = SPEED_CROUCH
	_is_crouching = not _is_crouching

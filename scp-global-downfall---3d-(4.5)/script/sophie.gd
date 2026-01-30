extends CharacterBody3D

@export var SPEED_DEFAULT : float = 5.0
@export var SPEED_CROUCH : float = 2.0
@export var JUMP_VELOCITY : float = 4.5
@export_range(5, 10, 0.1) var CROUCH_SPEED : float = 7.0
@export var MOUSE_SENSITIVITY : float = 0.5
@export var TILT_LOWER_LIMIT := deg_to_rad(-50.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Camera3D
@export var ANIMATIONPLAYER : AnimationPlayer
@export var CROUCH_SHAPECAST : Node3D
@onready var footsteps = $AudioStreamPlayer
@onready var character = $CharacterBody3D
@onready var hurtbox = $hurtbox
@onready var ani_walk = $HumanM_Walk01_Forward/walk_forward
@onready var ani_idle = $HumanM_Walk01_Forward/idle
@onready var ani_jump = $HumanM_Walk01_Forward/jump

var _walking : bool = false
var _speed : float 
var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3
var _is_crouchig : bool = false 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event: InputEvent) -> void:
	
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY
		
func _input(event):
	
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("crouch") and is_on_floor():
	#	toggle_crouch()
		pass
	if event.is_action_pressed("run") and _is_crouchig == false:
		_speed = 6
		print("Speed Higher")
		GlobalVar.sprinting = true
	elif event.is_action_released("run") or _is_crouchig == true:
		_speed = 3
		print("Speed Lower")
		GlobalVar.sprinting = false
		
func _update_camera(delta):
	
	# Rotates camera using euler rotation
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)

	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	CAMERA_CONTROLLER.rotation.z = 0.0

	_rotation_input = 0.0
	_tilt_input = 0.0
	
func _ready():
	# Get mouse input
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	_speed = SPEED_DEFAULT

	#CROUCH_SHAPECAST.add_exception(character)

func _physics_process(delta):
		
	if GlobalVar.hp <= 0:
		get_tree().quit()
	# Update camera movement based on mouse movement
	_update_camera(delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	#Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and _is_crouchig == false:
		velocity.y = JUMP_VELOCITY
		ani_jump.play("Untitled")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * _speed
		velocity.z = direction.z * _speed
		_walking = false
		GlobalVar.walking = true
		ani_idle.play("Untitled")
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		velocity.z = move_toward(velocity.z, 0, _speed)
		_walking = true
		GlobalVar.walking = false
		ani_walk.play("Untitled")
		
	if _walking == true:
		play_audio()
		

	move_and_slide()
	
#func toggle_crouch():
	#if _is_crouchig == true and CROUCH_SHAPECAST.is_colliding() == false:
	#	ANIMATIONPLAYER.play("Crouch", -1, -CROUCH_SPEED, true)
	#	set_movement_speed("default")
	#elif _is_crouchig == false:
	#	ANIMATIONPLAYER.play("Crouch", -1, CROUCH_SPEED)
	#	set_movement_speed("crouching")
		
func _on_animation_player_animation_started(anim_name):
	if anim_name == "Crouch":
		_is_crouchig = !_is_crouchig
		
func set_movement_speed(state : String):
	match state: 
		"default": 
			_speed = SPEED_DEFAULT
		"crouching":
			_speed = SPEED_CROUCH

func play_audio():
		footsteps.pitch_scale = randf_range(0.8,1.2)
		footsteps.play()

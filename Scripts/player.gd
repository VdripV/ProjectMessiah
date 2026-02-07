extends CharacterBody3D

const TIMER_LIMIT = 2.0
var timer = 0.0

@onready var camera: Camera3D = $CameraController/Camera3D
@onready var camera_controller: Node3D = $CameraController
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_hands: AnimationPlayer = $CameraController/Armpist/AnimationPlayer

@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var HORIZONTAL_SENS := 0.05
@export var VERTICAL_SENS := 0.2
@export var CROUCH_SHAPECAST : Node3D

const SPEED = 3.0
const JUMP_VELOCITY = 5.0
const CROUCH_SPEED = 4.0

var _tilt_input : float
var _rotation_input : float
var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3

var is_crouching : bool = false

func _ready() -> void:
	global.player = self
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	CROUCH_SHAPECAST.add_exception($".")

func _input(event: InputEvent):
	if Input.is_action_just_pressed("toggle_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	_mouse_input = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_tilt_input = -event.relative.y
		_rotation_input = -event.relative.x
		

func _update_camera(delta) -> void:
	_mouse_rotation.x += _tilt_input * delta * VERTICAL_SENS
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta * HORIZONTAL_SENS
	
	_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)

	camera_controller.rotate_x(deg_to_rad(_mouse_rotation.x))
	camera_controller.transform.basis = Basis.from_euler(_camera_rotation)
	
	global_transform.basis = Basis.from_euler(_player_rotation)


	_rotation_input = 0.0
	_tilt_input = 0.0

func _physics_process(delta: float) -> void:
	
	global.debug.add_property("Movement Speed", velocity.length(), 1)
	
	timer += delta
	if timer > TIMER_LIMIT:
		timer = 0.0
		print("fps: " + str(Engine.get_frames_per_second()))
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		if animation_hands.current_animation != "Armature|FPS_Pistol_Idle":
			animation_hands.play("Armature|FPS_Pistol_Idle")

	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_crouching:
		velocity.y = JUMP_VELOCITY
			
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		toggle_crouch()

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if animation_hands.current_animation != "Armature|FPS_Pistol_Walk":
			animation_hands.speed_scale = 0.5
			animation_hands.play("Armature|FPS_Pistol_Walk")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_hands.current_animation != "Armature|FPS_Pistol_Idle":
			animation_hands.play("Armature|FPS_Pistol_Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	_update_camera(delta)

func toggle_crouch():
	if !is_crouching:
		animation_player.play("crouching", -1, CROUCH_SPEED)
		is_crouching = !is_crouching
	elif is_crouching and CROUCH_SHAPECAST.is_colliding() == false:
		animation_player.play("crouching", -1, -CROUCH_SPEED, true)
		is_crouching = !is_crouching

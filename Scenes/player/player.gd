extends CharacterBody3D

const TIMER_LIMIT = 2.0
var timer = 0.0

@onready var camera: Camera3D = $CameraController/Camera3D
@onready var camera_controller: Node3D = $CameraController
@onready var sub_viewport_camera: Camera3D = %SubViewportCamera
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var footstep_walk: AudioStreamPlayer3D = $FootstepWalk
@onready var footstep_sprint: AudioStreamPlayer3D = $FootstepSprint
@onready var footstep_crouch: AudioStreamPlayer3D = $FootstepCrouch
@onready var jump_sound: AudioStreamPlayer3D = $Jump

@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var ACCELERATION := 0.1
@export var ACCELERATION_SPRINT := 0.2
@export var DECELERATION := 0.7
@export var HORIZONTAL_SENS := 0.05
@export var VERTICAL_SENS := 0.2


@export var SPEED_SPRINT := 5.0
@export var SPEED_DEFAULT := 4.0
@export var SPEED_CROUCH := 3.0
@export var JUMP_VELOCITY := 5.0

@export var CROUCH_SHAPECAST : Node3D

#@onready var hud = $HUD
#signal health_changed(current: float, max_value: float)
#signal armor_changed(current: float, max_value: float)
#signal ammo_changed(current: int, max: int)

var health: float = 100.0
var max_health: float = 100.0
var armor: float = 0
var max_armor: float = 100.0
var ammo: int = 30
var max_ammo: int = 30

var _tilt_input : float
var _rotation_input : float
var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3

var is_crouching : bool = false
var is_sprinting : bool = false
var current_speed : float = SPEED_DEFAULT
var current_acceleration : float = ACCELERATION

var _speed : float = SPEED_DEFAULT:
	set(value):
		_speed = value
		current_speed = value

func _ready() -> void:
	global.player = self
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	CROUCH_SHAPECAST.add_exception($".")
	
	#hud.update_health(health, max_health)
	#hud.update_armor(armor, max_armor)
	#hud.update_ammo(ammo, max_ammo)
	#
	#emit_health_signal()
	#emit_armor_signal()
	#emit_ammo_signal()
	
	footstep_walk.stream = preload("res://audio/walk_Grass.wav")
	footstep_sprint.stream = preload("res://audio/sprint_Grass.wav")
	footstep_crouch.stream = preload("res://audio/crouch_Grass.wav")
	jump_sound.stream = preload("res://audio/jump_Grass.wav")

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
	
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")

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
	_speed = SPEED_DEFAULT
	global.debug.add_property("Movement Speed", velocity.length(), 1)
	
	timer += delta
	if timer > TIMER_LIMIT:
		timer = 0.0
		print("fps: " + str(Engine.get_frames_per_second()))
	
	if not is_on_floor():
		velocity += get_gravity() * delta


	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_sprinting:
			velocity.x = lerp(velocity.x, direction.x * SPEED_SPRINT, ACCELERATION_SPRINT)
			velocity.z = lerp(velocity.z, direction.z * SPEED_SPRINT, ACCELERATION_SPRINT)
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED_DEFAULT, ACCELERATION)
			velocity.z = lerp(velocity.z, direction.z * SPEED_DEFAULT, ACCELERATION)
	else:
		var vel = Vector2(velocity.x,velocity.z)
		var temp = move_toward(vel.length(), 0, DECELERATION)
		velocity.x = vel.normalized().x * temp
		velocity.z = vel.normalized().y * temp
		
	move_and_slide()
	_update_camera(delta)

	

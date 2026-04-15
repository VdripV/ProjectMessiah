#@tool
#
extends Node3D
#
#@export var WEAPON_TYPE: Weapons:
	#set(value):
		#WEAPON_TYPE = value
		#if Engine.is_editor_hint():
			#load_weapon()
			#
#@onready var weapon_mesh: MeshInstance3D = $WeaponMesh
#
#@export_category("weapon sway")
#@export var sway_min : Vector2 = Vector2(-10.0, -10.0)
#@export var sway_max : Vector2 = Vector2(10.0, 10.0)
#@export_range(0, 0.2, 0.01) var sway_speed_position : float = 0.07
#@export_range(0, 0.2, 0.01) var sway_speed_rotation : float = 0.1
#@export_range(0, 0.25, 0.01) var sway_amount_position : float = 0.1
#@export_range(0, 50, 0.1) var sway_amount_rotation : float = 30.0
#
#var mouse_movement: Vector2
#var initial_position : Vector3
#var initial_rotation : Vector3
#
#var raycast = preload("res://Scenes/player/raycast.tscn")
#
#func _ready() -> void:
	#global.weapon = self
	## Always load once when game starts
	#load_weapon()
	#initial_position = position
	#initial_rotation = rotation_degrees
#
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#mouse_movement = event.relative
	#if event.is_action_pressed('weapon1'):
		#WEAPON_TYPE = load("res://Source/player/sci-fi/sci-fi_gun/blaster.tres")
		#print("Load weapon1")
		#load_weapon()
		#initial_position = position
		#initial_rotation = rotation_degrees
	#if event.is_action_pressed('weapon2'):
		#WEAPON_TYPE = load("res://Source/player/sci-fi/sci-fi_gun2/black_gun_res.tres")
		#print("Load weapon2")
		#load_weapon()
		#initial_position = position
		#initial_rotation = rotation_degrees
#
#func _process(_delta):
	## In editor: update every frame so inspector changes are reflected
	#if Engine.is_editor_hint():
		#load_weapon()
#
#func load_weapon() -> void:
	#if not WEAPON_TYPE:
		#return
	#weapon_mesh.mesh = WEAPON_TYPE.mesh
	#position = WEAPON_TYPE.position
	#rotation_degrees = WEAPON_TYPE.rotation
#
#
#func sway_weapon(delta) -> void:
	## Clamp mouse movement
	#mouse_movement.x = clamp(mouse_movement.x, sway_min.x, sway_max.x)
	#mouse_movement.y = clamp(mouse_movement.y, sway_min.y, sway_max.y)
	## Lerp weapon position based on mouse movement, relative to the initial position
	#position.x = lerp(position.x, initial_position.x - (mouse_movement.x * sway_amount_position) * delta, sway_speed_position)
	#position.y = lerp(position.y, initial_position.y + (mouse_movement.y * sway_amount_position) * delta, sway_speed_position)
	## Lerp weapon rotation based on mouse movement, relative to the initial rotation
	#rotation_degrees.y = lerp(rotation_degrees.y, initial_rotation.y + (mouse_movement.x * sway_amount_rotation) * delta, sway_speed_rotation)
	#rotation_degrees.x = lerp(rotation_degrees.x, initial_rotation.x - (mouse_movement.y * sway_amount_rotation) * delta, sway_speed_rotation)
#
#func _physics_process(delta: float) -> void:
	#sway_weapon(delta)
#
#
##func _attack() -> void:
	##var camera = global.player.camera
	##var space_state = camera.get_world_3d().direct_space_state
	##var screen_center = get_viewport().size / 2
	##var origin = camera.project_ray_origin(screen_center)
	##var end = origin + camera.project_ray_normal(screen_center) * 1000
	##var query = PhysicsRayQueryParameters3D.create(origin, end)
	##query.collide_with_bodies = true
	##var result = space_state.intersect_ray(query)
	##if result:
		##_raycast(result.get("position"))
##
##func _raycast(position: Vector3) -> void:
	##var instance = raycast.instantiate()
	##get_tree().root.add_child(instance)
	##instance.global_position = position
	##await get_tree().create_timer(3).timeout
	##instance.queue_free()

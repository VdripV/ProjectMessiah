class_name DashingPlayerState

extends State

@export var ANIMATION : AnimationPlayer
@export var DASH_SPEED : float = 20.0
@export var DASH_DURATION : float = 0.2
@export var DASH_COOLDOWN : float = 2.0

var dash_direction : Vector3
var dash_timer : float = 0.0
var can_dash : bool = true
var is_dashing : bool = false

func enter() -> void:
	# Сохраняем направление движения или взгляд игрока
	if global.player.velocity.length() > 0:
		dash_direction = global.player.velocity.normalized()
	else:
		dash_direction = -global.player.transform.basis.z
	
	# Устанавливаем скорость рывка
	global.player.velocity = dash_direction * DASH_SPEED
	global.player.velocity.y = 0  # обнуляем вертикальную скорость для горизонтального рывка
	
	dash_timer = DASH_DURATION
	can_dash = false
	is_dashing = true
	
	# Звук рывка (добавьте звук в global.player)
	#if global.player.has_method("play_dash_sound"):
		#global.player.play_dash_sound()

func exit() -> void:
	is_dashing = false
	# Запускаем таймер кулдауна
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true

func update(delta: float) -> void:
	dash_timer -= delta
	
	if dash_timer <= 0 and is_dashing:
		# Рывок закончен
		if global.player.velocity.length() > 0:
			transition.emit("WalkingPlayerState")
		else:
			transition.emit("IdlePlayerState")

func physics_update(delta: float) -> void:
	if not is_dashing:
		return
	# Применяем гравитацию во время рывка
	global.player.velocity += global.player.get_gravity() * delta
	
	if global.player.is_on_floor() and dash_timer <= 0:
		# Если мы на земле после рывка
		pass

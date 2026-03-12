extends CanvasLayer

@onready var health_bar = $VBoxContainer/HealthBar
@onready var armor_bar = $VBoxContainer/ArmorBar
@onready var ammo_label = $VBoxContainer/AmmoLabel

func update_health(value: float, max_value: float):
	health_bar.value = value
	health_bar.max_value = max_value

func update_armor(value: float, max_value: float):
	armor_bar.value = value
	armor_bar.max_value = max_value

func update_ammo(current: int, max: int):
	ammo_label.text = str(current) + " / " + str(max)

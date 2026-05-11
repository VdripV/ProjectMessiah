extends PanelContainer

@onready var property_container = %VBoxContainer	

var frames_per_second : String


func _ready() -> void:
	visible = false
	
	global.debug = self


func _process(delta: float) -> void:
	
	if !visible: return
	
	frames_per_second = "%.2f" % (1.0/delta)
	#property.text = property.name + ": " + frames_per_second


func add_property(title : String, value, order):
	var target
	target = property_container.find_child(title, true, false)
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target, order)
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"): visible = !visible

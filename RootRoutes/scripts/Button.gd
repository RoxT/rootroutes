extends Area2D


var active := false
var root:Area2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		root.look_at(get_viewport().get_mouse_position())
		
func deactivate():
	active = false


func activate(rooty:Area2D):
	active = true
	add_child(rooty)
	root = rooty
	root.position = position

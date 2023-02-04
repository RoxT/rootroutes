extends Area2D

var active := false
var free_root:FreeRoot

signal hovered(Node2D)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		# While dragging, move the sprite with the mouse.
		var pointer = to_local(event.position).snapped(Vector2(48, 48))
		free_root.position = pointer
		free_root.choose_anim(pointer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate(rooty:Area2D):
	if !active:
		active = true
		add_child(rooty)
		rooty.position = position
		rooty.origin = position
		free_root = rooty
		

func _on_Root_mouse_entered():
	emit_signal("hovered", self)

extends Area2D

var FreeRoot = preload("res://scenes/FreeRoot.tscn")
var free_root:Area2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	free_root = FreeRoot.instance()
	$RootDown.activate(free_root)

func _input(event):
	if event is InputEventMouseMotion:
		# While dragging, move the sprite with the mouse.
		$Sprite.position = to_local(event.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Root_hovered(root: Node2D):
	root.activate(free_root)

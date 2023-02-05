extends Area2D
class_name Root, "res://textures/root-downright.png"

var active := false
var free_root:FreeRoot
const STEP = 48
onready var player:AnimatedSprite = $RootSprite
var age = 0;
const maturity = 5

signal hovered(Node2D)
signal clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func tick():
	age = age+1
	if age >= maturity:
		player.play("mature")
	
func _unhandled_input(event):
	if !active: return
	if event is InputEventMouseMotion:
		# While dragging, move the sprite with the mouse.
		var pointer = to_local(event.position).snapped(Vector2(STEP, STEP))
		pointer.x = clamp(pointer.x, -STEP, STEP)
		pointer.y = clamp(pointer.y, -STEP, STEP)
		free_root.position = pointer
		free_root.choose_anim(pointer)
	if event is InputEventMouseButton && event.is_pressed() == true:
		get_tree().set_input_as_handled() 
		if free_root.position == Vector2.ZERO: return
		active = false
		var new_root = load("res://scenes/Root.tscn").instance()
		new_root.position = position + free_root.position
		get_parent().add_child(new_root)
		new_root.connect("hovered", get_parent(), "_on_Root_hovered")
		new_root.connect("clicked", get_parent(), "_on_clicked")
		new_root.choose_anim(free_root.position)
		free_root.queue_free()
		emit_signal("clicked")
		
func deactivate():
	if active:
		free_root.queue_free()
		active = false

func activate(rooty:Area2D):
	if !active:
		active = true
		rooty
		rooty.position = position
		rooty.origin = position
		free_root = rooty
		add_child(rooty)
		

func _on_Root_mouse_entered():
	emit_signal("hovered", self)
	
	
func choose_anim(pointer):
	if abs(pointer.x) > STEP || abs(pointer.y) > STEP: return
	if pointer.x == STEP:
		if pointer.y == STEP:
			player.play("down-right")
		elif pointer.y == -STEP:
			player.play("up-right")
		else:
			player.play("right")
	elif pointer.x == -STEP:
		if pointer.y == STEP:
			player.play("down-left")
		elif pointer.y == -STEP:
			player.play("up-left")
		else:
			player.play("left")
	else:
		if pointer.y == STEP:
			player.play("down")
		else:
			player.play("up")

extends Node2D

var FruitingBody = preload("res://scenes/FruitingBody.tscn")
var rng = RandomNumberGenerator.new()
onready var camera = $Camera2D
const CAMERA_SPEED = 500
const ZOOM_SPEED = 0.5
const STEP = 48
var current_body:FruitingBody

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var err = $YouDied/Timer.connect("timeout", self, "_on_YouDied_Timer_timeout")
	if err != OK: print(err)
	new_body()
	
func new_body():
	get_tree().call_group("item", "set_visible", false)
	var pos = $Spawn.get_children()[rng.randi_range(0, $Spawn.get_children().size()-1)].position
	var new_body = FruitingBody.instance()
	new_body.position = pos
	$YouDied.visible = false
	$YouDied.position = new_body.position
	camera.position = new_body.position + Vector2(0, 150)
	current_body = new_body
	add_child(new_body)

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		camera.position.x += CAMERA_SPEED *	 delta
	elif Input.is_action_pressed("ui_left"):
		camera.position.x -= CAMERA_SPEED * delta
	if Input.is_action_pressed("ui_up"):
		camera.position.y -= CAMERA_SPEED * delta
	elif Input.is_action_pressed("ui_down"):
		camera.position.y += CAMERA_SPEED * delta
	if Input.is_action_pressed("ui_in"):
		var desired = camera.zoom - Vector2(ZOOM_SPEED * delta, ZOOM_SPEED * delta)
		camera.zoom = Vector2(clamp(desired.x, 0.3, 2.0), clamp(desired.x, 0.3, 2.0))
	elif Input.is_action_pressed("ui_out"):
		var desired = camera.zoom + Vector2(ZOOM_SPEED * delta, ZOOM_SPEED * delta)
		camera.zoom = Vector2(clamp(desired.x, 0.3, 2.0), clamp(desired.x, 0.3, 2.0))

func _unhandled_input(event):
	if !is_instance_valid(current_body): return
	if event is InputEventMouseMotion:
		var pointer = get_global_mouse_position()
		if pointer.y <= current_body.position.y+48: return
		current_body.handle_hover(pointer)

func _on_restart():
	$YouDied/Label.text = "re-spawning...."
	$YouDied.visible = true
	$YouDied/Timer.start()

func _on_YouDied_Timer_timeout():
	new_body()



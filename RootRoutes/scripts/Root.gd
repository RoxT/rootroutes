extends Area2D
class_name Root, "res://textures/root-downright.png"
	
var active := false
var free_root:FreeRoot
const STEP = 48
onready var player:AnimatedSprite = $RootSprite
var age = 0;
const maturity = 7
var is_dead := false
const USED = "used"
const ITEM = "item"

signal hovered(node)
signal clicked
signal inv_changed(thing, amount)
signal trade()

# Called when the node enters the scene tree for the first time.
func _ready():
	var errs = []
	errs.append(connect("hovered", get_parent(), "_on_Root_hovered"))
	errs.append(connect("clicked", get_parent(), "_on_clicked"))
	errs.append(connect("inv_changed", get_parent(), "_on_Root_inv_changed"))
	errs.append(connect("trade", get_parent(), "_on_trade"))
	for e in errs: if e != OK: print(e)
	$RootSquish.play()
	
func tick():
	age = age+1
	if age >= maturity:
		player.play("mature")
		
func handle_hover(pointer: Vector2):
	if !is_instance_valid(free_root): return
	var hover = to_local(pointer).snapped(Vector2(STEP, STEP))
	hover.x = clamp(hover.x, -STEP, STEP)
	hover.y = clamp(hover.y, -STEP, STEP)
	free_root.position = hover
	free_root.choose_anim(hover)
	
func _unhandled_input(event):
	if !active: return
	if event is InputEventMouseButton && event.is_pressed() == true:
		var areas = free_root.get_overlapping_areas()
		if !areas.empty(): print(str(areas))
		for a in areas:
			if a.visible == true: break
			for c in a.get_children():
				if c is Sprite || c is AnimatedSprite:
					match c.name:
						"Rock":
							a.visible = true
							return
						"Fossil":
							$GoodChime.play()
							a.visible = true
							$Pause.start()
							$Nitro.visible = true
							emit_signal("inv_changed", "nitro", 10)
						"Fern":
							$GoodChime.play()
							a.visible = true
							$Pause.start()
							$Nitro.visible = true
							emit_signal("inv_changed", "nitro", 10)
						"Fish":
							$GoodChime.play()
							a.visible = true
							$Pause.start()
							$Nitro.visible = true
							emit_signal("inv_changed", "nitro", 10)
						"Worm":
							$BadBuzzer.play()
							a.visible = true
							$Pause.start()
							$MinusSugar.visible = true
							emit_signal("inv_changed", "sugar", -1)
							return
						"Tree":
							$GoodChime.play()
							a.visible = true
							$Pause.start()
							$Trade.visible = true
							emit_signal("trade")
						"DeadRoot":
							for i in a.get_parent().get_children():
								i.visible = true
						var a_name:
							print("Unkn: " + a_name)
							return
		
		get_tree().set_input_as_handled() 
		if free_root.position == Vector2.ZERO: return
		active = false
		var new_root = load("res://scenes/Root.tscn").instance()
		new_root.position = position + free_root.position
		get_parent().add_child(new_root)
		new_root.choose_anim(free_root.position)
		free_root.queue_free()
		emit_signal("clicked")

func deactivate():
	if active:
		free_root.queue_free()
		active = false

func activate(rooty:Area2D):
	if active == false:
		active = true
		rooty.position = position
		rooty.origin = position
		free_root = rooty
		add_child(rooty)
		

func _on_Root_mouse_entered():
	emit_signal("hovered", self)
	
func die():
	var anim = player.animation + "-dead"
	player.animation = anim
	queue_free()

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


func _on_Pause_timeout():
	get_tree().call_group("message", "set_visible", false)
	$Nitro.visible = false

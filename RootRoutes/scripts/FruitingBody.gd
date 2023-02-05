extends Area2D

class_name FruitingBody, "res://textures/mushroom.png"

var FreeRoot = preload("res://scenes/FreeRoot.tscn")
var DeadRoot = preload("res://scenes/DeadRoot.tscn")
var active_root:Root
signal restart

var sugar := 10
var nitro := 10

var trading := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var errs = []
	errs.append(connect("restart", get_parent(), "_on_restart"))
	for e in errs: if e != OK: print(e)
	update_ineventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_clicked():
	if trading > 0:
		var trade = min(trading, nitro)
		nitro = nitro - trade
		sugar = sugar + trade
	
	sugar = sugar - 1
	update_ineventory()
	if sugar <= 0:
		var dead_roots = []
		$Inventory/Label.text = ""
		for c in get_children():
			if c is Root:
				var dead_root = DeadRoot.instance()
				dead_root.position = c.position
				dead_root.get_node("DeadRoot").animation = c.player.animation + "-dead"
				dead_roots.append(dead_root)
				c.die()
		for c in dead_roots:
			add_child(c)
		emit_signal("restart")
	else:
		for c in get_children():
			if c is Root:
				c.tick()
				
func update_ineventory():
	$Inventory/Label.text = "Sugar: " + str(sugar) + "\n" + "Nitogen: " + str(nitro)

func _on_trade():
	trading = trading + 1

func _on_Root_hovered(root: Node2D):
	if active_root:
		active_root.deactivate()
		active_root = null
	root.activate(FreeRoot.instance())
	active_root = root


func _on_Root_inv_changed(thing, amount):
	match thing:
		"nitro":
			nitro = nitro + amount
		"sugar":
			sugar = sugar + amount
	update_ineventory()

extends Area2D

var FreeRoot = preload("res://scenes/FreeRoot.tscn")
var active_root:Root

var sugar := 10
var nitro := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_clicked():
	sugar = sugar - 1
	$Inventory/Label.text = "Sugar: " + str(sugar) + "\n" + "Nitogen: " + str(nitro)
	if sugar <= 0:
		$Inventory/Label.text = "YOU DIED"
		for c in get_children():
			if c is Root:
				c.die()
		get_tree().paused = true
	else:
		for c in get_children():
			if c is Root:
				c.tick()

func _on_Root_hovered(root: Node2D):
	if active_root:
		active_root.deactivate()
		active_root = null
	root.activate(FreeRoot.instance())
	active_root = root
	



func _on_RootDown_clicked():
	pass # Replace with function body.

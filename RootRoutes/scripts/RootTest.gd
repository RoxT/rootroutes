extends Node2D

var FruitingBody = preload("res://scenes/FruitingBody.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_restart():
	$YouDied/Label.text = "re-spawning...."
	$YouDied.visible = true
	$YouDied/Timer.start()


func _on_YouDied_Timer_timeout():
	get_tree().call_group("item", "set_visible", false)
	var pos = $Spawn.get_children()[rng.randi_range(0, $Spawn.get_children().size()-1)].position
	var new_body = FruitingBody.instance()
	new_body.position = pos
	$YouDied.visible = false
	add_child(new_body)

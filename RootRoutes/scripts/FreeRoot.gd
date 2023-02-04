extends Area2D

class_name FreeRoot, "res://textures/root-down.png"

onready var player:AnimatedSprite = $AnimatedSprite
onready var origin:Vector2 = get_parent().position

const STEP = 48

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func choose_anim(pointer):
	if pointer.x > origin.x:
		if pointer.y > origin.y:
			player.play("down-right")
			$Label.text = "down-right"
		elif pointer.y < origin.y:
			player.play("up-right")
			$Label.text = "up-right"
		else:
			player.play("right")
			$Label.text = "right"
	elif pointer.x < origin.x:
		if pointer.y > origin.y:
			player.play("down-left")
		elif pointer.y < origin.y:
			player.play("up-left")
		else:
			player.play("left")
	else:
		if pointer.y > origin.y:
			player.play("down")
		else:
			player.play("up")

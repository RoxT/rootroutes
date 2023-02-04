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
			player.flip_v = false
		elif pointer.y < origin.y:
			player.play("down-right")
			player.flip_v = true
		else:
			player.play("right")
			player.flip_v = false
	elif pointer.x < origin.x:
		if pointer.y > origin.y:
			player.play("down-left")
			player.flip_h = false
		elif pointer.y < origin.y:
			player.play("down-left")
			player.flip_h = true
		else:
			player.play("left")
			player.flip_h = false
	else:
		if pointer.y > origin.y:
			player.play("down")
		else:
			player.play("down")
			player.flip_v = true

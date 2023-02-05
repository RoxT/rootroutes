extends Area2D
class_name FreeRoot, "res://textures/arrow-right.png"

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
	if abs(pointer.x) > STEP || abs(pointer.y) > STEP: return
	$Label.text = "o: " + str(origin) + " p: " + str(pointer)
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

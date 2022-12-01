extends Node2D

export (int) var TIME = 60

onready var collider = $Area2D
onready var asprite = $AnimatedSprite

var stop = false

func _ready():
	collider.connect("body_entered", self, "collision_detected")

func _process(delta):
	if not stop:
		asprite.play("default")
	if stop:
		asprite.stop()

func collision_detected(body):
	if body.is_in_group("Player"):
		var timer = get_node(str(body.get_path())+'/Timer')
		timer.start(timer.time_left + TIME)
		self.queue_free()

func time_stop():
	stop = true

func time_start():
	stop = false

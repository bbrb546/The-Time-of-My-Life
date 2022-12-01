extends Node2D

export (PackedScene) var bulletScene

const RATE = 0.5 # same as BulletShooter
const DEGREES = [0, 45, 90, 135, 180, 225, 270, 315] # 0 = 360 i think

var stop = false

onready var stimer = $Timer # self timer
onready var sprite = $AnimatedSprite

func _ready():
	stimer.wait_time = RATE
	stimer.connect("timeout", self, "shoot")

func _process(delta):
	if sprite: # to prevent some errors that come up
		if not stop:
			sprite.play("default")
		if stop:
			sprite.stop()

func shoot():
	if not stop:
		for i in DEGREES:
			var new_bullet = bulletScene.instance() #using same technique as in BulletTurret
			var bullet_parent = Node2D.new()
			
			bullet_parent.rotation_degrees = i
			
			self.add_child(bullet_parent)
			bullet_parent.add_child(new_bullet)

func time_stop():
	stop = true
	for i in get_children(): # should work?
		for e in i.get_children():
			if 'Bullet' in e.name:
				e.stop = stop

func time_start():
	stop = false
	for i in get_children(): # should work?
		for e in i.get_children():
			if 'Bullet' in e.name:
				e.stop = stop

func kill_bullets():
	for i in get_children(): # should work?
		var chicken = false
		for e in i.get_children():
			if 'Bullet' in e.name:
				e.queue_free()
				chicken = true
		if chicken:
			i.queue_free()

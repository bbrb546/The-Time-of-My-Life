extends Node2D

export (PackedScene) var bulletScene # for some reason snake_case doesn't work for this var
export (float) var delay = 0.0

var rate = 0.75 # rate of fire

var bullet_list = [] # for time stops
var stop = false
var first_time = true

onready var animated_sprite = $AnimatedSprite # note: possible issue with frames 6-7 and 7-8


func _ready(): # connecting with timer
	$Timer.connect("timeout", self, "spawn_bullet")
	$Timer.start(rate + delay)

func _process(delta):
	if not stop: # do animation if time isn't stopped
		animated_sprite.play("default")
	else: # stop animation once time is stopped
		animated_sprite.stop()

func spawn_bullet(): # setting up the bullet
	if not stop:
		var new_bullet = bulletScene.instance()
		self.add_child(new_bullet)
		#new_bullet.setup(player_timer_path
		$Timer.start(rate)

func time_stop(): # daniel connect this to the time stop signal idk what it is
	#print('time stop')
	stop = true
	for i in get_children():
		if 'Bullet' in i.name:
			i.stop = stop

func time_start(): # daniel connect this to the time stop signal idk what it is
	#print('time stop')
	stop = false
	for i in get_children():
		if 'Bullet' in i.name:
			i.stop = stop
			
func kill_bullets():
	for i in get_children():
		if 'Bullet' in i.name:
			i.queue_free()

extends Node2D

export (PackedScene) var bullet_scene # NOTE TO SELF: do the deactivation stuff

export (int) var MAX_LEN = 1000 # max len of the laser
const ROTATION_SPD = 1.5
const DEACTIVATION_TIME = 4
const RATE = 0.45 # 0.2 seconds faster than bulletShooter

onready var timer = $Timer
onready var dtimer = $DeactivationTimer
onready var rc2d = $RC2DParent/RayCast2D
onready var rc2d_parent = $RC2DParent
onready var head = $Head

var target = 42 # placeholder

var bullets = [] # for time stops

var stop = false # the turret turning on-off
var active = false
var deactivating = false
var first_time = true

func _ready():
	dtimer.wait_time = DEACTIVATION_TIME
	timer.wait_time = RATE
	#dtimer.connect("timeout", self, "turn_off") # deactivation timer
	timer.connect("timeout", self, "_on_Timer_timeout")
	
	# daniel forced me to do this:
	$StaticBody2D.add_to_group(str(self.name))
	rc2d.add_exception($StaticBody2D)
	
func _physics_process(delta):
	if not stop: # for time stops
		budget_process(delta)
	else:
		head.stop()
		timer.set_paused(true)
		
func budget_process(delta): # main processing
	if not active: # if the turret isn't active
		timer.set_paused(true)
		dtimer.set_paused(true)
		
		rc2d.rotation_degrees += ROTATION_SPD
		rc2d.cast_to = Vector2(1, 0) * MAX_LEN # snapppy, fix later
		
		head.rotation_degrees = rc2d.rotation_degrees # head animation
		head.play("default")
		
		if rc2d.is_colliding():
			if rc2d.get_collider().is_in_group("Player"):
				target = rc2d.get_collider()
				self.active = true
				first_time = true
	
	if active: # if the turret is active
		# note: Put all turrets in a BulletShooters node
		var target = get_parent().get_parent().get_node("NewPlayer") # get player positionh
		var angle_to_target = global_position.direction_to(target.global_position).angle()
		
		rc2d.global_rotation = angle_to_target
		
		# head animation stuff
		head.play("inactive(active)")
		
		if not deactivating:
			head.rotation = angle_to_target
		timer.set_paused(false) # bullet shoot timer
		
		if rc2d.is_colliding():
			if rc2d.get_collider().is_in_group("Player"):
				first_time = true
				dtimer.set_paused(true)
				deactivating = false
			else: # if it can't detect player
				if first_time:
					first_time = false
					dtimer.start(dtimer.wait_time)
					dtimer.set_paused(false)
				deactivating = true

func _on_Timer_timeout(): # spawn a bullet
	if not stop and not deactivating: # only if time isn't stopped
		var bullet_parent = Node2D.new() #  setting up teh bullet
		var new_bullet = bullet_scene.instance()
		
		new_bullet.bullet_turret_origin = str(self.name)
		
		get_tree().current_scene.add_child(bullet_parent)
		bullet_parent.add_child(new_bullet)
		bullets.append(bullet_parent)
		
		bullet_parent.global_position = global_position
		bullet_parent.global_rotation = rc2d.global_rotation

func turn_off():
	self.active = false

func time_stop_toggle(): #connect with any time stop
	stop = not stop
	for i in get_children(): # should work?
		for e in i.get_children():
			if 'Bullet' in e.name:
				e.stop = stop

func time_stop():
	stop = true
	for i in bullets:
		for e in i.get_children():
			e.stop = stop

func time_start():
	stop = false
	for i in bullets:
		for e in i.get_children():
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

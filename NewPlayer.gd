extends KinematicBody2D

const TS_EXPONENTIAL = 6

signal stopped_time # signals
signal resumed_time
signal out_of_time
signal reached_end

export var max_hits = 5 # exported vars
export var timestop_limit = 7
export var timestop_cooldown = 0
export var time = 60 # standard value, change based on level length

var speed = 400 # movement / death
var velocity = Vector2()
var failed = false

var timestop_timer = 0 # timestop
var timestop_cooldown_timer = timestop_cooldown
var stopped_time = false
var new_time_left = 0
var wait_time = 0

onready var tens = $CanvasLayer/TimeNumbers/Number
onready var ones = $CanvasLayer/TimeNumbers/Number2
onready var colon = $CanvasLayer/TimeNumbers/Number3
onready var tensec = $CanvasLayer/TimeNumbers/Number4
onready var onesec = $CanvasLayer/TimeNumbers/Number5

func _ready():
	$Timer.wait_time = time
	
	colon.input2 = true # never touch this again lmao

func _process(delta):
	if not failed:
		# timenumber()
		$CanvasLayer/TimerBar.value = $Timer.time_left
		velocity = Vector2()
		
#		if velocity.y != 0:
#			$AnimatedSprite.animation = 'up'
#			$AnimatedSprite.flip_v = velocity.y > 0
#		elif velocity.x != 0:
#			$AnimatedSprite.animation = 'right'
#			$AnimatedSprite.flip_v = false
#			$AnimatedSprite.flip_h = velocity.x < 0 
			
		if not stopped_time:
			
			if timestop_timer > 0 and timestop_cooldown_timer > 0:
				timestop_cooldown_timer -= delta	
				$CanvasLayer/timestop_text.text = ('cooldown:'+str(timestop_cooldown_timer))	
			if timestop_cooldown_timer <= 0:
				timestop_timer = 0	
				timestop_cooldown_timer = timestop_cooldown
				$CanvasLayer/timestop_text.text = ''

func _physics_process(delta):
	timenumber()
	
	if not failed:
		
		if Input.is_action_just_released("stop_time") or timestop_timer >= timestop_limit:
			
			if timestop_cooldown_timer == timestop_cooldown and stopped_time == true:
				#print('resumed')
				timestop_cooldown = timestop_timer
				stopped_time = false
				emit_signal("resumed_time")
				#$Timer.start(new_time_left)	
				#print(new_time_left)	
				#$Timer.set_paused(false)
				
		elif Input.is_action_just_pressed("stop_time") and timestop_cooldown_timer == timestop_cooldown and timestop_timer == 0:
			emit_signal("stopped_time") 
			new_time_left = $Timer.get_time_left()*3/4
			stopped_time = true
			
		elif stopped_time:
			
			if ($Timer.time_left - pow((timestop_timer/TS_EXPONENTIAL),2)) > 0:
				timestop_timer+=delta
				$Timer.start($Timer.time_left - pow((timestop_timer/TS_EXPONENTIAL),2))
				print($Timer.time_left - pow((timestop_timer/TS_EXPONENTIAL),2))
				$CanvasLayer/timestop_text.text = 'time stopped:'+str(timestop_timer)
			else: 
				$Timer.start(0)
				stopped_time = false
		
		velocity = velocity.normalized() * speed
		#move_and_slide(velocity)
		for index in get_slide_count():
			var collision = get_slide_collision(index)

			velocity.slide(collision.normal)
#			if 'Bullet2' in collision.collider.name:
#				collision.collider.queue_free()
#
#				$Timer.start($Timer.time_left -wait_time/max_hits)
			if collision.collider.name == "Block":
				hide()
				$CollisionShape2D.set_deferred("disabled", true)
				$Camera2D.set_deferred('current', false)
				emit_signal('reached_end')
				$Timer.set_paused(true)

		if Input.is_action_pressed('move_right'):
			velocity.x += 1
		if Input.is_action_pressed('move_left'):
			velocity.x -= 1
		if Input.is_action_pressed('move_down'):
			velocity.y += 1
		if Input.is_action_pressed('move_up'):
			velocity.y -= 1

func start(new_position):
	position = new_position
	visible = true
	$Camera2D.set_deferred('current', true)
	failed = false
	new_time_left = 0
	timestop_cooldown_timer = 3
	timestop_timer = 1

func timenumber(): # tens: ten minutes, ones: 1 minute, tensec = 10 seconds, onesec = 1 second
	time = $Timer.time_left
	
	# get seconds and minutes
	var seconds = int(time) % 60
	var minutes = (int(time) - seconds) / 60
	
	# get the ones + tens place of the seconds + minutes, directly set the input to it
	onesec.input = seconds % 10
	tensec.input = (seconds - onesec.input) / 10
	
	ones.input = int(minutes) % 10
	tens.input = (minutes / 10) - (ones.input / 10)

func _on_Timer_timeout():
	emit_signal("out_of_time")
	failed = true
	stopped_time = false

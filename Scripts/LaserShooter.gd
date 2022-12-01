extends Node2D

const MAX_LENGTH = 2000 # max range of laser, excluding walls
const LASER_TIMER = 5 # interval for how long the laser toggles damage

var damage = false # if the laser is on
var stop = false # if time is paused

var first_time = true # used for testing purposes

onready var beam = $Beam # the graphics
onready var dbeam = $BeamDeactivated
onready var end = $End
onready var rc2d = $RayCast2D
onready var timer = $Timer

func _ready():
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.wait_time = LASER_TIMER # a little long winded

func _physics_process(delta):
	if not stop: # if time isn't stopped
		timer.set_paused(false)
		budget_process(delta) # standard operation
	else: # if time is stopped
		timer.set_paused(true)
		beam.region_rect.end.x = 0
		dbeam.region_rect.end.x = 0

func budget_process(delta): # tutorial officially says to use _physics_process()
	if damage: # if the laser is "on"
		rc2d.cast_to = Vector2(1, 0) * MAX_LENGTH # setup the target for the raycast
	
		if rc2d.is_colliding(): # if it's colliding
			if check_collision(): # so the laser passes through player
				end.global_position = rc2d.get_collision_point()
		else: # otherwise
			end.global_position = rc2d.cast_to
		
		# graphics
		dbeam.region_rect.end.x = 0
		beam.region_rect.end.x = end.position.length()
	else: # if the laser isn't on (recharging)
		rc2d.cast_to = Vector2(0, 0) # turn off laser when not casting (possibly replace with sepearete laser animation?)
		beam.region_rect.end.x = 0
		dbeam.region_rect.end.x = end.position.length()

func check_collision(): # checking for collisions
	if rc2d.get_collider():
		var hit = rc2d.get_collider() # the thing hit by the laser
		if hit.is_in_group("Player"): # if it's player
			var player = get_node(str(hit.get_path()))
			var itimer = get_node(str(hit.get_path())+'/Timer')
			var time = itimer.time_left - itimer.wait_time/player.max_hits if itimer.time_left > \
			itimer.wait_time/player.max_hits else 0.05
			itimer.start(time)
			
			return false
		if hit.is_in_group("Solids"):
			return true

func _on_Timer_timeout(): # togglging laser
	if damage:
		damage = false #should work?
	else:
		damage = true

func toggle_time_stop(): # link up with time stop code
	stop = not stop

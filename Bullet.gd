extends Area2D

var stop = false
var bullet_turret_origin = false

func _process(delta):
	if not stop: # if time isn't stopped the move the bullet forward
		var velocity = Vector2(1, 0)
		self.position += velocity.normalized() * 3.8

func _on_Bullet_body_entered(body): # once it collides
	#  print(body.name)
	if not bullet_turret_origin:
		if body.is_in_group("Solids") and not body in get_parent().get_children() and not body in get_parent().get_parent().get_children(): # if collision is wall
				queue_free()
	if bullet_turret_origin:
		if body.is_in_group("Solids") and not body.is_in_group(bullet_turret_origin):
			queue_free()
	if body.is_in_group("Player"): # if it's the player
		#print(body.name)
		queue_free() # damage script
		var player = get_node(str(body.get_path()))
		var timer = get_node(str(body.get_path())+'/Timer')
#		var time = timer.time_left*1/2 if timer.time_left*1/2 > timer.wait_time/8 else \
#		timer.wait_time/get_node(str(body.get_path())+'/Timer').wait_time
		var time = timer.time_left - player.wait_time/player.max_hits if timer.time_left > \
		player.wait_time/player.max_hits else 0.05
		timer.start(time)

func _on_Bullet_area_entered(area):
	if area.is_in_group("Solids"):
		queue_free()

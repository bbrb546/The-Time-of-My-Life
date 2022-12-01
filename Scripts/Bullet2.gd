extends KinematicBody2D
signal hit_player
var stop = false
var velocity = Vector2()
func setup(direction):
	if direction == 'up':
		velocity = Vector2(0, -1)
	elif direction == 'down':
		velocity = Vector2(0, 1)
	elif direction == 'right':
		velocity = Vector2(1,0)
	elif direction == 'left':
		velocity = Vector2(-1,0)
		
func _process(delta):
	#var velocity = Vector2(1, 0)
	#self.position += velocity.normalized() * 4
	var collision = move_and_collide(velocity*0)
	if not stop:
		collision = move_and_collide(velocity*4)
	if collision:
		#(collision.collider.name)
		
		if collision.collider.name == 'NewPlayer':
			queue_free()
			get_node('/root/Level1/NewPlayer/Timer').start(get_node('/root/Level1/NewPlayer/Timer').time_left*1/2)
			
		else:
			queue_free()
			
	name = 'Bullet2'
	

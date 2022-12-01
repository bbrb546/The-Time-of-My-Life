extends Node2D

var finished = true
var level = 1

onready var timer = get_node("NewPlayer/Timer")

export var time = 180

func _ready():
	timer.wait_time = time
	$NewPlayer.wait_time = time
	$NewPlayer.start($StartPosition.position)
	timer.start()
	$NewPlayer/CanvasLayer/TimerBar.max_value = $NewPlayer/Timer.wait_time
	
	$Restart.hide()
	for i in get_tree().get_nodes_in_group('bulletShooters'):
		i.add_to_group('Solids')
	
	$Music.play()

func _on_NewPlayer_reached_end():	
	SceneChanger.change_scene("res://MainScene.tscn")
	yield(get_tree().create_timer(0.2),"timeout")
	$Block/AnimatedSprite.animation = 'Complete'

func _on_NewPlayer_out_of_time():
	SceneChanger.change_scene("res://Scenes/Restarts/Restart.tscn", 0.00001)
	timer.stop()
	$NewPlayer.set_deferred('visible', false)
	$NewPlayer/Camera2D.set_deferred('current', false)
	get_tree().call_group('bulletShooters','time_stop')
	get_tree().call_group('bulletShooters', 'kill_bullets')
	$NewPlayer/AnimatedSprite.animation = 'regular'

func _on_Restart_pressed():
	$Restart.hide()
	$NewPlayer.start($StartPosition.position)
	$NewPlayer/Timer.start(time)
	get_tree().call_group('bulletShooters','time_start')

func _on_NewPlayer_stopped_time():
	#write in obstacle mechanics here
	get_tree().call_group('bulletShooters','time_stop')
	#print('time')
	#$NewPlayer.modulate = '#ffe800'
	$NewPlayer/AnimatedSprite.animation = 'timestop'

func _on_NewPlayer_resumed_time():
	get_tree().call_group('bulletShooters','time_start')
	#$NewPlayer.modulate = Color(255,255,6485)
	$NewPlayer/AnimatedSprite.animation = 'regular'

func _on_Music_finished():
	yield(get_tree().create_timer(2),"timeout")
	$Music2.play()

func _on_Music2_finished():
	yield(get_tree().create_timer(2),"timeout")
	$Music.play()

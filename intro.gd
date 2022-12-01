extends Node2D


var text = ['In the year 2042, scientists discovered how to stop time',
"The 4th dimension could now be explored and researched", 
"However, humans in the future decided experiments were unethical",
"And so they collected test subjects from the past",
"You are one of them", 
"Your success is vital for scientific advancement"]
var text_counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Label.visible_characters = 0
	$Label.text = text[0]
	text_counter = 0


func _on_Timer_timeout():
	if $Label.visible_characters < $Label.text.length():
		$Label.visible_characters+=1
	else:
		pass
func _on_Button_pressed():
	text_counter +=1
	if text_counter < len(text):
			$Label.visible_characters = 0
			$Label.text = text[text_counter]
			$Timer.start()
	else:
		SceneChanger.change_scene('res://Scenes/Level1.tscn')

extends Control

func _ready(): # connecting up the things
	$PlayButton.connect("pressed", self, "play_button_pressed")
	$QuitButton.connect("pressed", self, "quit_button_pressed")

# navigation, basic buttons
func play_button_pressed():
	SceneChanger.change_scene("res://Scenes/LevelSelection.tscn", 0.1)
func quit_button_pressed():
	get_tree().quit()

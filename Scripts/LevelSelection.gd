extends Control

func _ready():
	$BackButton.connect("pressed", self, "back_button_pressed")
	$LevelOneButton.connect("pressed", self, "level_one_button_pressed")
	$LevelTwoButton.connect("pressed", self, "level_two_button_pressed")
	$LevelThreeButton.connect("pressed", self, "level_three_button_pressed")
	$LevelFourButton.connect("pressed", self, "level_four_button_pressed")

func back_button_pressed():
	SceneChanger.change_scene("res://MainScene.tscn", 0.1)

# level buttons, theoretically it could be collapsed to make simpler but too lazy
func level_one_button_pressed():
	SceneChanger.change_scene("res://Scenes/Level1.tscn")
func level_two_button_pressed():
	SceneChanger.change_scene("res://Scenes/Level2.tscn")
func level_three_button_pressed():
	SceneChanger.change_scene("res://Scenes/Level4.tscn")
func level_four_button_pressed():
	SceneChanger.change_scene("res://Scenes/Level3.tscn")

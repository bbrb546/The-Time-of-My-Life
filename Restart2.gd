extends Node2D

onready var mmbutton = $MainMenu
onready var restart = $Restart

func _ready():
	mmbutton.connect("pressed", self, "go_to_mm")
	restart.connect("pressed", self, "prestart")

func go_to_mm():
	SceneChanger.change_scene("res://MainScene.tscn")

func prestart():
	SceneChanger.change_scene("res://Scenes/Level3.tscn")

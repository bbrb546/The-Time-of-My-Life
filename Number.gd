extends Node2D

var input = 0
var input2 = false

var numbers = []
var colon = "placeholder"

onready var sprite = $Sprite

func _ready():
	for i in range (0, 10):
		numbers.append(load("res://Sprites/Numbers/" + str(i) + ".png"))
	
	colon = load("res://Sprites/Numbers/colon.png")

func _process(_delta):
	if not input2:
		sprite.texture = numbers[input]
	if input2:
		sprite.texture = colon

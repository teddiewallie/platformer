extends Node2D

@onready var camera = $Player/Camera2D

func _ready():
	camera.zoom = Vector2(0.5, 0.5)

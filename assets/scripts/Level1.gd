extends Node2D

@onready var camera = $Player/Camera2D

func _ready():
	camera.zoom = Vector2(1.0, 1.0)

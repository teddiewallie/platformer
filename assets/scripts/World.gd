extends Node2D

@onready var ticker: Label = $CanvasLayer/Ticker

var level_start_time: int

func _ready():
	level_start_time = Time.get_ticks_msec()
	Engine.time_scale = 1.2

func _physics_process(delta):
	var elapsed = (Time.get_ticks_msec() - level_start_time) / 1000.0
	ticker.text = format_time(elapsed)

	if Input.is_action_just_pressed("ui_timescale_up"):
		Engine.time_scale += 0.1
			
	if Input.is_action_just_pressed("ui_timescale_down"):
		Engine.time_scale -= 0.1

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	var millis = int(seconds * 1000) % 1000

	return "%02d:%02d.%03d" % [minutes, secs, millis]

extends TileMapLayer

var move_distance = 184.0
var move_duration = 2.0
var is_moving = false
var can_trigger = true

var start_position
var tween
var player

@onready var trigger = $SlidingBarTrigger


func _ready():
	start_position = position
	$HitBox.body_entered.connect(_on_hitbox_entered)
	trigger.body_entered.connect(_on_trigger_body_entered)
	Events.player_reset.connect(reset)


func _on_trigger_body_entered(body):
	if body is CharacterBody2D and can_trigger:
		player = body
		can_trigger = false
		slide_right()


func reset():
	if tween and tween.is_running():
		tween.kill()

	position = start_position
	is_moving = false
	can_trigger = false

	# Wait until the physics engine has updated the teleport.
	await get_tree().physics_frame
	await get_tree().physics_frame

	_check_player_outside_trigger()


func _check_player_outside_trigger():
	if not is_instance_valid(player):
		can_trigger = true
		return

	if not trigger.overlaps_body(player):
		can_trigger = true
	else:
		# Keep checking until the player leaves the trigger.
		await get_tree().physics_frame
		_check_player_outside_trigger()


func _on_hitbox_entered(body):
	if body is CharacterBody2D:
		if body.current_mode.can_die():
			Events.player_died.emit()


func slide_right():
	if is_moving:
		return

	is_moving = true

	tween = create_tween()
	tween.tween_property(
		self,
		"position:x",
		position.x + move_distance,
		move_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	is_moving = false

class_name Mode

var player = null
var speed = 300

var acceleration = 200
var gravity = 200

var flip_h = false

func _init(player, speed):
	self.player = player
	self.speed = speed

func init(flip_h):
	pass

func exit():
	pass

func handle_gravity(delta):
	pass

func handle_animation():
	pass

func horizontal_movement(delta):
	if Input.is_action_pressed("ui_right"):
		if player.velocity.x > speed:
			if not player.is_on_floor():
				return

	if Input.is_action_pressed("ui_left"):
		if player.velocity.x < speed * -1:
			if not player.is_on_floor():
				return

	var ui_right = Input.get_action_strength("ui_right")
	var ui_left = Input.get_action_strength("ui_left")
	
	var target_speed = (ui_right - ui_left) * speed

	if player.is_on_floor():
		player.velocity.x = move_toward(
			player.velocity.x,
			target_speed,
			(acceleration * 4) * delta
		)
	else:
		player.velocity.x = move_toward(
			player.velocity.x,
			target_speed,
			(acceleration / 2) * delta
		)

func can_die():
	pass

func vertical_movement():
	pass

func handle_collisions():
	pass

func handle_flip():
	if Input.is_action_pressed("ui_left"):
		flip_h = true;

	if Input.is_action_pressed("ui_right"):
		flip_h = false;

class_name ModeGaiden

extends Mode

var is_poof = false
var can_double_jump = true

var max_speed = 100
var jump_velocity = -120

var jump_counter = 0
var max_jumps = 2

func wall_ray_flip():
	player.wall_ray_top_gaiden.target_position.x = abs(
		player.wall_ray_top_gaiden.target_position.x
	) * (-1 if player.animated_gaiden.flip_h else 1)

	player.wall_ray_bottom_gaiden.target_position.x = abs(
		player.wall_ray_bottom_gaiden.target_position.x
	) * (-1 if player.animated_gaiden.flip_h else 1)

func wall_ray_enabled(shouldEnable):
	player.wall_ray_top_gaiden.enabled = shouldEnable
	player.wall_ray_bottom_gaiden.enabled = shouldEnable

func wall_ray_colliding():
	return player.wall_ray_top_gaiden.is_colliding() \
			and player.wall_ray_bottom_gaiden.is_colliding()


func _init(player):
	super(player, max_speed)

func init(flip_h):
	self.flip_h = flip_h
	player.collision_gaiden.disabled = false
	player.animated_gaiden.visible = true
	wall_ray_enabled(true)
	player.animated_gaiden.play("poof")

	if not player.is_on_floor():
		max_jumps = 3

func exit():
	player.collision_gaiden.disabled = true
	player.animated_gaiden.visible = false
	wall_ray_enabled(false)

func handle_gravity(delta):
	if player.is_on_wall() and wall_ray_colliding():
		player.velocity.y = 0
	else:
		player.velocity.y += player.gravity * delta

func horizontal_movement(delta):
	if player.is_on_wall() and wall_ray_colliding():
		return

	super.horizontal_movement(delta)

func can_wall_jump():
	if not wall_ray_colliding():
		return false

	if not player.is_on_wall():
		return false

	if player.is_on_wall() and player.is_on_floor() and wall_ray_colliding():
		return false

	var wall_normal = player.get_wall_normal()

	if flip_h:
		return wall_normal.x > 0
	else:
		return wall_normal.x < 0

func vertical_movement():
	wall_ray_flip()

	if Input.is_action_just_pressed("ui_mode_action"):
		if player.is_on_floor():
			player.velocity.y = jump_velocity
			jump_counter = 1
			max_jumps = 2
		elif can_wall_jump():
			player.velocity.y = jump_velocity
			player.velocity.x = max_speed/2 if flip_h else -max_speed/2
		else:
			if Input.is_action_just_pressed("ui_mode_action") and jump_counter < max_jumps:
				jump_counter += 1
				player.velocity.y = jump_velocity

func wall_is_on_the_left():
	return player.is_on_wall() and player.get_wall_normal().x > 0

func handle_animation():
	super.handle_flip()

	player.animated_gaiden.flip_h = flip_h

	if player.animated_gaiden.animation == "poof" \
			and player.animated_gaiden.is_playing():
				return

	if player.is_on_wall() and not player.is_on_floor() and wall_ray_colliding():
			flip_h = wall_is_on_the_left()
			player.animated_gaiden.flip_h = flip_h
			player.animated_gaiden.play("wall")
			return

	if not player.is_on_floor():
		player.animated_gaiden.play("jump")
		return

	if Input.is_action_just_released("ui_mode_action"):
		player.animated_gaiden.play("walk");

	if Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right"):
		player.animated_gaiden.play("walk")

	if !Input.is_anything_pressed():
		player.animated_gaiden.play("stand")

func handle_collisions():
	if player.is_touching_bad_platform():
		player.to_spawn()
		player.animated_gaiden.play("poof")

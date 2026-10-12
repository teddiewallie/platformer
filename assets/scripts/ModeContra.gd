class_name ModeContra

extends Mode

var max_speed = 50

func _init(player):
	super(player, max_speed)

func init(flip_h):
	self.flip_h = flip_h
	player.collision_contra.disabled = false
	player.animated_contra.visible = true
	player.animated_contra.play("poof")

func exit():
	player.collision_contra.disabled = true
	player.animated_contra.visible = false

func handle_gravity(delta):
	player.velocity.y += player.gravity * delta

func horizontal_movement(delta):
	super.horizontal_movement(delta)

func vertical_movement():
	pass

func handle_animation():
	super.handle_flip()
	player.animated_contra.flip_h = flip_h

	if Input.is_action_just_pressed("ui_mode_action"):
		var projectile = preload("res://assets/scenes/Projectile.tscn").instantiate()
		projectile.direction = -1 if flip_h else 1
		projectile.global_position = player.global_position + Vector2(projectile.direction * 12, -2)
		player.get_parent().add_child(projectile)

	if player.animated_contra.animation == "poof" \
			and player.animated_contra.is_playing():
				return

	if not player.is_on_floor():
		player.animated_contra.play("float")
		return

	if Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right"):
		player.animated_contra.play("walk")

	if !Input.is_anything_pressed():
			player.animated_contra.play("stand")
			
func handle_collisions():
	if player.is_touching_bad_platform():
		player.to_spawn()
		player.animated_contra.play("poof")

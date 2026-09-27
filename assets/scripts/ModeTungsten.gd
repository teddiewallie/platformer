class_name ModeTungsten

extends Mode

var max_speed = 0

var ignored_platforms = []

func _init(player):
	super(player, max_speed)

func init(flip_h):
	self.flip_h = flip_h
	player.velocity.x = 0
	player.velocity.y = 0
	player.collision_tungsten.disabled = false
	player.animated_tungsten.visible = true
	player.animated_tungsten.play("poof")

func exit():
	# Restore any weak platforms Tungsten has ignored.
	for platform in ignored_platforms:
		platform.get_node("CollisionShape2D").set_deferred("disabled", false)

	ignored_platforms.clear()

	player.collision_tungsten.disabled = true
	player.animated_tungsten.visible = false

func handle_gravity(delta):
	player.velocity.y += player.gravity * delta

func horizontal_movement(delta):
	pass

func vertical_movement():
	pass

func handle_animation():
	super.handle_flip()

	if player.animated_tungsten.animation == "poof" \
			and player.animated_tungsten.is_playing():
		return

	player.animated_tungsten.play("stand")

func handle_collisions():
	for i in player.get_slide_collision_count():
		var collision = player.get_slide_collision(i)
		var collider = collision.get_collider()

		if collider.is_in_group("weak_platform"):
			if collider not in ignored_platforms:
				collider.get_node("CollisionShape2D").set_deferred("disabled", true)
				ignored_platforms.append(collider)

				var hit_position = collision.get_position()
				player.get_parent().get_node("TungstenCrash").global_position = hit_position + Vector2(-4, 4)
				player.get_parent().get_node("TungstenCrash").play("default")

	# Restore platforms once Tungsten has passed below them.
	for platform in ignored_platforms.duplicate():
		if player.global_position.y > platform.global_position.y:
			platform.get_node("CollisionShape2D").set_deferred("disabled", false)
			ignored_platforms.erase(platform)

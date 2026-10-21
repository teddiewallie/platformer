class_name ModeTungsten

extends Mode

var max_speed = 0

var current_collider = null

var ignored_platforms = {}

var tungsten_crash = preload("res://assets/scenes/Tungsten_crash.tscn")

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
	for platform in ignored_platforms:
		platform.get_node("CollisionShape2D").set_deferred("disabled", false)
	if current_collider:
		current_collider.collision_enabled = true;

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

func can_die():
	return false

func handle_collisions():
	for i in player.get_slide_collision_count():
		var collision = player.get_slide_collision(i)
		var collider = collision.get_collider()

		var hit_normal = collision.get_normal()
		if hit_normal.y > 0:
			continue

		if !collider.is_in_group("weak"):
			continue
			
		current_collider = collider

		var hit_position = collision.get_position()

		var crash = tungsten_crash.instantiate()
		player.get_parent().add_child(crash)
		crash.global_position = hit_position + Vector2(-4, 4)
		crash.play("default")
		
		collider.collision_enabled = false;
		await player.get_tree().create_timer(0.5).timeout
		collider.collision_enabled = true;
		current_collider = null

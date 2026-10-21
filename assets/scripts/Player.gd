extends CharacterBody2D

var gravity = 200

var flip_h = false
var current_mode
var old_mode

@onready var spawn_position = global_position

@onready var collision_contra = $CollisionContra
@onready var animated_contra = $AnimatedContra

@onready var collision_gaiden = $CollisionGaiden
@onready var animated_gaiden = $AnimatedGaiden

@onready var collision_tungsten = $CollisionTungsten
@onready var animated_tungsten = $AnimatedTungsten

@onready var wall_ray_top_gaiden = $WallRayTopGaiden
@onready var wall_ray_bottom_gaiden = $WallRayBottomGaiden

var mode_contra = ModeContra.new(self)
var mode_gaiden = ModeGaiden.new(self)
var mode_tungsten = ModeTungsten.new(self)

func _ready():
	current_mode = mode_contra
	old_mode = current_mode
	current_mode.init(flip_h)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_suicide"):
		Events.player_died.emit()
		
	switch_modes()

	current_mode.handle_gravity(delta)

	current_mode.horizontal_movement(delta)
	current_mode.vertical_movement()
	current_mode.handle_flip()

	current_mode.handle_animation()
	move_and_slide()
	current_mode.handle_collisions()

func switch_modes():
	old_mode = current_mode

	if Input.is_action_pressed("ui_switch_mode_1"):
		current_mode = mode_contra

	if Input.is_action_pressed("ui_switch_mode_2"):
		current_mode = mode_gaiden

	if Input.is_action_pressed("ui_switch_mode_3"):
		current_mode = mode_tungsten

	if current_mode == old_mode:
		return

	old_mode.exit()
	current_mode.init(old_mode.flip_h)
	
func is_touching_bad():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider.is_in_group("bad"):
			return true
			
func to_spawn():
	print("TO SPAWN")
	global_position = spawn_position
	velocity.x = 0
	velocity.y = 0
	Events.player_reset.emit()

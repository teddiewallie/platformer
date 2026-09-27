class_name Projectile
extends Area2D

var speed = 500
var direction = 1

@onready var ray = $RayCast2D
@onready var animated = $AnimatedSprite2D
@onready var sprite = $Sprite2D

func _ready():
	animated.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	ray.target_position.x = speed * delta * direction
	ray.force_raycast_update()

	if ray.is_colliding():
		sprite.visible = false
		global_position = ray.get_collision_point()
		animated.play("default")
		set_physics_process(false)
		return

	global_position.x += speed * direction * delta

func _on_animation_finished():
	if animated.animation == "hit":
		queue_free()

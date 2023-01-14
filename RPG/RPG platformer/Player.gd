extends KinematicBody2D
class_name Player

var right = "ui_right"
var left = "ui_left"
var up = "ui_up"

var velocity = Vector2.ZERO
var direction: Vector2
var gravity = 30
var speed = Vector2(300,600)

onready var sprite = $Sprite
onready var timer = $Timer

func _physics_process(delta: float) -> void:
	var jump_is_interrupted = Input.is_action_just_released(up) and velocity.y < 0.0
	direction = get_direction()
	#set velocity get velocity
	velocity = get_velocity(velocity, speed, direction, jump_is_interrupted)
	movement()

func movement() -> void:
#gravity, jump
	if is_on_floor() == false:
		velocity.y += gravity
	if Input.is_action_just_pressed(up):
		if is_on_floor() == false:
			timer.start()
#set horizontal velocity to zero when key is released
	if Input.is_action_just_released(right):
		velocity.x = 0
	if Input.is_action_just_released(left):
		velocity.x = 0
#movement related sprite settings
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
#Move and slide
	velocity = move_and_slide(velocity, Vector2.UP)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength(right) - Input.get_action_raw_strength(left),
		-1.0 if Input.is_action_just_pressed(up) and is_on_floor() else 0.0
	)

func get_velocity(
	linear_velocity: Vector2,
	speed: Vector2,
	direction: Vector2,
	jump_is_interrupted: bool
) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1:
		new_velocity.y = speed.y * direction.y
	if jump_is_interrupted:
		new_velocity.y = 0
	return new_velocity 

func _on_Timer_timeout():
	if is_on_floor() == true:
		direction.y = -1

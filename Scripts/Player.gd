extends CharacterBody2D

const SPEED = 500.0
const MAX_JUMP = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumps = 2

func _physics_process(delta):
	
	if is_on_floor():
		jumps = 2
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if jumps > 1:
			jumps -= 1

	if Input.is_action_just_pressed("ui_accept") and jumps > 0:
		velocity.y = MAX_JUMP
		jumps -= 1
		
	#MOVEMENT ALONG X-AXIS
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

extends CharacterBody2D

const SPEED = 70.0
const MAX_JUMP = -250.0
const ACCELERATION = 10.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumps = 2
var is_jumping = false

func _physics_process(delta):
	
	if is_on_floor():
		jumps = 2
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		elif velocity.y > 0:
			$AnimatedSprite2D.play("fall")
		if jumps > 1:
			jumps -= 1

	if Input.is_action_just_pressed("jump") and jumps > 0:
		velocity.y = MAX_JUMP
		is_jumping = true
		jumps -= 1
		
	#MOVEMENT ALONG X-AXIS
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION)
		if is_on_floor():
			$AnimatedSprite2D.play("walk")
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		if velocity.x == 0 and is_on_floor():
			$AnimatedSprite2D.play("idle")
	
	if Input.is_action_just_pressed("dash"):
		velocity.y = 0
		gravity = 0
		$AnimatedSprite2D.play("dash")
		if $AnimatedSprite2D.flip_h:
			velocity.x = -200
		else:
			velocity.x = 200
		
		await get_tree().create_timer(0.3).timeout
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		
	move_and_slide()

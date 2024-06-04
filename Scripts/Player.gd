extends CharacterBody2D

const SPEED = 70.0
const MAX_JUMP = -250.0
const ACCELERATION = 10.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumps = 2
var dashes = 1

enum STATE {
	RUN,
	DASH,
	MIDAIR,
	IDLE,
}

var current_state = STATE.IDLE

func _physics_process(delta):
	
	match current_state:
		STATE.IDLE:
			$AnimatedSprite2D.play("idle")
			
		STATE.RUN:
			$AnimatedSprite2D.play("walk")
			
		STATE.MIDAIR:
			velocity.y += gravity * delta
			if jumps > 1:
				jumps = 1
			if velocity.y > 0:
				$AnimatedSprite2D.play("fall")
			else:
				$AnimatedSprite2D.play("jump")
				
		STATE.DASH:
			dashes -= 1
			velocity.y = 0
			$AnimatedSprite2D.play("dash")
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	if not is_on_floor() and current_state != STATE.DASH:
		current_state = STATE.MIDAIR

	if is_on_floor() and current_state != STATE.DASH:
		jumps = 2
		dashes = 1
		if velocity.x == 0:
			current_state = STATE.IDLE
		else:
			current_state = STATE.RUN

	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	
	if Input.is_action_just_pressed("jump") and jumps > 0 and current_state != STATE.DASH:
		velocity.y = MAX_JUMP
		jumps -= 1
	
	if Input.is_action_just_pressed("dash") and dashes > 0:
		current_state = STATE.DASH
		if direction:
			velocity.x = 200 * direction
		else:
			velocity.x = 200
	
	move_and_slide()
	
func _on_animated_sprite_2d_animation_finished():
	if current_state == STATE.DASH:
		current_state = STATE.IDLE

extends CharacterBody2D
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D

var walk_speed = 100
var run_speed = 250
var gravity = 900
var jump_force = -300

enum State {
	WALK,
	IDLE,
	RUN,
	JUMP,
	FALL
}
var state = State.IDLE

func _physics_process(delta: float) -> void:
	var dir = Input.get_axis("left", "right")
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	update_state(dir)
	update_movSpeed(dir)
	update_anim()
	
	move_and_slide()

func update_state(dir):
	if not is_on_floor():
		if velocity.y < 0:
			state = State.JUMP
		else:
			state = State.FALL
	else:
		if dir == 0:
			state = State.IDLE
		elif Input.is_action_pressed("run"):
			state = State.RUN
		else:
			state = State.WALK
		
func update_movSpeed(dir):
	match state:
		State.WALK:
			velocity.x = dir * walk_speed
		State.RUN:
			velocity.x = dir * run_speed
		State.IDLE:
			velocity.x = 0
		State.JUMP, State.FALL:
			velocity.x = dir * walk_speed

func update_anim():
	match state:
		State.WALK:
			walk()
		State.IDLE:
			idle()
		State.RUN:
			run()
		State.JUMP:
			jump()
		State.FALL:
			fall()
			

func walk():
	if anim.animation != "walk":
		anim.play("walk")
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0
	
func idle():
	if anim.animation != "idle":
		anim.play("idle")
		
func run():
	if anim.animation != "run":
		anim.play("run")
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0
		
func jump():
	if anim.animation != "jump":
		anim.play("jump")
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0
	
func fall():
	if anim.animation != "fall":
		anim.play("fall")
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0

extends KinematicBody2D

var velocity = Vector2.ZERO

signal state_changed(state)
enum State{
	IDLE,		#0
	WALK,		#1
	JUMP,		#2
	CROUCH,		#3
	SPRINT,		#4
	WALLSLIDE	#5
	WALLJUMP	#6
}

var Cstate = State.IDLE

export (int) var Regular_Speed = 350
export (int) var Sprint_Speed = 500
export (int) var Speed = Regular_Speed
export (int) var crouch_speed = 175
export (int) var gravity = 1500
export (int) var Jump_Speed = -500
export (int) var wallslide_speed = 100
export (int) var wallslide_gravity = 100
var wallsliding = false #this will be a state

func set_state(state):
	Cstate = state
	emit_signal("state_changed", Cstate)

func _process(delta):
	$Label.text = str("State:", Cstate)
	
	#state switches go here
	match Cstate:
			State.IDLE:
				#if u walk go to walk state
				if velocity.x !=0:
					set_state(State.WALK)
				#if u hug wall go to wallslide state
				if(is_on_wall() and !is_on_floor()):
					set_state(State.WALLSLIDE)
			State.WALK:
				#set your speed back to normal
				Speed = Regular_Speed
				#if you stop moving go to idle state
				if velocity.x == 0:
					set_state(State.IDLE)
				#if u hug wall go to wallslide state
				if(is_on_wall() and !is_on_floor()):
					set_state(State.WALLSLIDE)
			State.JUMP:
				#if u landed on floor go to walk state
				if is_on_floor():
					set_state(State.WALK)
				#if u hug wall go to wallslide state
				if(is_on_wall() and !is_on_floor()):
					set_state(State.WALLSLIDE)
			State.CROUCH:
				#set speed to crouching speed
				Speed = crouch_speed
				#change collisions to the correct ones
				$Entitycolcrouching.disabled = false
				$Entitycolstanding.disabled = true
				#if you release the crouch button, revert changes and go to walk state
				if not Input.is_action_pressed("Crouch"):
					if not $Crouchcheckerback.is_colliding() && not $Crouchcheckerfront.is_colliding():
						$Entitycolcrouching.disabled = true
						$Entitycolstanding.disabled = false
						set_state(State.WALK)
			State.SPRINT:
				#set speed to sprint speed
				Speed = Sprint_Speed
				#if you stop pressing sprint, got to walk state
				if not Input.is_action_pressed("Sprint"):
					set_state(State.WALK)
				#if u hug wall go to wallslide state
				if(is_on_wall() and !is_on_floor()):
					set_state(State.WALLSLIDE)
			State.WALLSLIDE:
				#if you reach the floor go to walk state
				if !is_on_wall():
					set_state(State.WALK)
			State.WALLJUMP:
				if $WallslideCheckRight.is_colliding() && Input.is_action_pressed("Walk_Right"):
					velocity.y = Jump_Speed
					set_state(State.WALK)
				if $WallslideCheckLeft.is_colliding() && Input.is_action_pressed("Walk_Left"):
					velocity.y = Jump_Speed
					set_state(State.WALK)
				set_state(State.WALK)

#determining button input and speed
func get_movement_input():

	velocity.x = 0 
	if Input.is_action_pressed("Walk_Right"):
		velocity.x += Speed
	if Input.is_action_pressed("Walk_Left"):
		velocity.x -= Speed

#actually moving and jumping code
func _physics_process(delta):
		
	####wallsliding
	if Cstate == State.WALLSLIDE:
		velocity.y +=(wallslide_gravity * delta)
		velocity.y = min(velocity.y, wallslide_speed)
		
	####walljumping
	if Cstate == State.WALLSLIDE && Input.is_action_pressed("Jump"):
		set_state(State.WALLJUMP)
	
	get_movement_input()
	#jumping and falling
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("Jump") && Cstate != State.CROUCH:
		set_state(State.JUMP)
		if is_on_floor():
				velocity.y = Jump_Speed
#				on_ground = true
#			else:
#				on_ground = false
	#crouching
	if Input.is_action_pressed("Crouch") && is_on_floor():
		set_state(State.CROUCH)
	#sprinting
	if Input.is_action_pressed("Sprint") && is_on_floor() && Cstate != State.CROUCH:
		set_state(State.SPRINT)


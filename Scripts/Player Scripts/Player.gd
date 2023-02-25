extends CharacterBody2D

@export var JumpForce: int = -100
@export var JumpReleaseForce: int = -70
@export var MaxSpeed: int = 85
@export var Acceleration: int = 15
@export var Friction: int = 10
@export var Gravity: int = 5
@export var AdditionalFallGravity: int = 2
@export var DoubleJumpForce: int = -120
@export var ReducedGravityDuration: float = 0.1
@export var IncreasedAirControlDuration: float = 0.2
@export var IncreasedAirControl: int = 20
@export var RunningSpeedIncrease: int = 20

var desired_velocity = Vector2.ZERO
var double_jump_available = true # variable to keep track of whether double jump is available
var double_jump_timer = 0
var increased_air_control_timer = 0
var is_running = false

func _physics_process(_delta):
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if input.x == 0:
		apply_friction()
		$AnimatedSprite2D.animation = "Idle"
	else :
		apply_acceleration(input.x)
		is_running = Input.is_action_pressed("running")
		$AnimatedSprite2D.animation = "Run" if is_running else "Walk"
		
	if input.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif input.x < 0:
		$AnimatedSprite2D.flip_h = true
	if is_on_floor():
		double_jump_available = true # reset double jump availability when checked floor
		double_jump_timer = 0
		increased_air_control_timer = 0
		if Input.is_action_pressed("up") :
			velocity.y = JumpForce
			velocity.y += JumpForce * 0.1 # add small amount of upward velocity when first leaving the ground
	else :
		$AnimatedSprite2D.animation = "Jump"
		if Input.is_action_just_released("up") and velocity.y < JumpReleaseForce:
			velocity.y = JumpReleaseForce
		if velocity.y > 0:
			velocity.y += AdditionalFallGravity
		if Input.is_action_just_pressed("up") and double_jump_available: # check if double jump is available and input is pressed
			if is_running:
				velocity.y = DoubleJumpForce + RunningSpeedIncrease
			else:
				velocity.y = DoubleJumpForce
			double_jump_timer = ReducedGravityDuration
			double_jump_available = false # set double jump to unavailable
			increased_air_control_timer = IncreasedAirControlDuration
	# check if reduced gravity timer is still active
	if double_jump_timer > 0:
		double_jump_timer -= _delta
		if double_jump_timer <= 0:
			velocity.y += Gravity
		else:
			velocity.y += Gravity
	
	var was_in_air = not is_on_floor()
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		$AnimatedSprite2D.animation = "Run"
		$AnimatedSprite2D.frame = 1
	
func apply_gravity():
	velocity.y += Gravity

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, Friction)

func apply_acceleration(amount):
	if is_running and amount != 0 and is_on_floor():
		desired_velocity.x = (MaxSpeed + RunningSpeedIncrease) * amount
	else:
		desired_velocity.x = MaxSpeed * amount
	velocity.x = move_toward(velocity.x, desired_velocity.x, Acceleration)

func _input(event):
	if event.is_action_pressed("pickup"):
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)

class_name Player
extends CharacterBody3D


var SPEED = 2.5
var JUMP_VELOCITY = 3.5
var DEF_SPEED = 2.5
var SP_SPEED = 5.0
var SN_SPEED = 1.5
var CR_SPEED = 1.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _input(event: InputEvent) -> void:
	# FP Camera rotation
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * 0.005)
			$PlyrCam.rotate_x(-event.relative.y * 0.005)
			$PlyrCam.rotation.x = clamp($PlyrCam.rotation.x, -PI/2, PI/2)
	
	# Sprinting
	if Input.is_action_pressed("Sprint"):
		SPEED = SP_SPEED
	elif Input.is_action_just_released("Sprint"):
		SPEED = DEF_SPEED
	
	# Sneaking
	if Input.is_action_just_pressed("Sneak"):
		SPEED = SN_SPEED
	elif Input.is_action_just_released("Sneak"):
		SPEED = DEF_SPEED
	
	# Crouching
	if Input.is_action_pressed("Crouch"):
		SPEED = CR_SPEED
	elif Input.is_action_just_released("Crouch"):
		SPEED = DEF_SPEED

class_name Player
extends CharacterBody3D


var SPEED = 2.5
var JUMP_VELOCITY = 4.5
var DEF_SPEED = 2.5
var SP_SPEED = 5.0
var SN_SPEED = 1.5
var CR_SPEED = 1.0
var Crouched : bool = false
var SENSITIVITY = 0.005

@export var Health = 100

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$AnimationPlayer.play("Idle")

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
	
	# Pushing physics objects
	var Push_Force = 0.50
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * Push_Force)

# Input
func _input(event: InputEvent) -> void:
	# FP Camera rotation
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * SENSITIVITY)
			$PlyrCam.rotate_x(-event.relative.y * SENSITIVITY)
			$PlyrCam.rotation.x = clamp($PlyrCam.rotation.x, -PI/2, PI/2)
	
	# Sprinting
	if Input.is_action_pressed("Sprint") and Crouched == false:
		if $Interface/Attributes/StaminaBar.value > 0:
			SPEED = SP_SPEED
		elif $Interface/Attributes/StaminaBar.value <= 0:
			SPEED = SN_SPEED
		$Interface/Attributes/StaminaBar.show()
	else:
		SPEED = DEF_SPEED
		$Interface/Attributes/StaminaBar.hide()
	
	# Sneaking
	if Input.is_action_just_pressed("Sneak") and Crouched == false:
		SPEED = SN_SPEED
	elif Input.is_action_just_released("Sneak") and Crouched == false:
		SPEED = DEF_SPEED
	
	# Crouching
	if Input.is_action_just_pressed("Crouch"):
		if Crouched == false:
			SPEED = CR_SPEED
			Crouched = true
			JUMP_VELOCITY = 1.5
			$AnimationPlayer.play("Crouching")
			$PlyrCollision/PlyrMesh.hide()
			$PlyrCollision.set_deferred("disabled", true)
			$CrouchCollision.set_deferred("disabled", false)
		else:
			SPEED = DEF_SPEED
			Crouched = false
			JUMP_VELOCITY = 4.5
			$AnimationPlayer.play("Idle")
			$PlyrCollision/PlyrMesh.show()
			$PlyrCollision.set_deferred("disabled", false)
			$CrouchCollision.set_deferred("disabled", true)
	

# Player damage
func damage(dmgAmount : int):
	Health -= dmgAmount
	
	if Health < 0:
		Health = 0
	
	if Health > 100:
		Health = 100
	
	$Interface/Attributes/HealthBar.value = Health

# Healing Player
func heal(healAmount : int):
	Health += healAmount
	
	if Health > 100:
		Health = 100
	
	$Interface/Attributes/HealthBar.value = Health

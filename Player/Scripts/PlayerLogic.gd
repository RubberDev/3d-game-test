class_name PlayerProto
extends CharacterBody3D

var SPEED = 3.5
var WALK_SPEED = 2.5
var SPRINT_SPEED = 5.5
var JUMP_VELOCITY = 4.5
var CROUCH_SPEED = 2.0
var CAN_UNCROUCH : bool = true
var SENSITIVITY = 0.005

var Health = 100
var Has_Died : bool = false

var MouseModeJailed = true
var Console_Shown = false
var Is_Paused : bool = false

var FlashlightOn : bool = false
@onready var Current_Scene = get_tree().current_scene

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print(Current_Scene)

func _process(_delta: float) -> void:
	if $CollisionShape3D/CrouchCheck.is_colliding() == true:
		CAN_UNCROUCH = false
	else:
		CAN_UNCROUCH = true

# Movement, Console button, physics interactions
func _physics_process(delta: float) -> void:
	# Interactables
	if $Camera3D/Reach.is_colliding():
		var Collider = $Camera3D/Reach.get_collider()
		if Collider.has_method("Interact") or Collider.is_in_group("Interactable"):
			if Input.is_action_just_pressed("Interact"):
				Collider.Interact()
		else:
			pass

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Handle movement
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var vel2d := Vector2(velocity.x, velocity.z)
	var DEACC : float = SPEED * 0.1
	if direction:
		if MouseModeJailed == true:
			$PlayerAnims.play("Headbob")
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			pass
	else:
		vel2d = vel2d.move_toward(Vector2.ZERO, DEACC)
		velocity.x = vel2d.x
		velocity.z = vel2d.y
		$PlayerAnims.play("Idle")
		
	move_and_slide()
	
	# Handle pushing things
	var Push_Force = 0.50
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * Push_Force)
	
# Hide player console if X button clicked on UI
func _on_exit_button_pressed() -> void:
	$PlayerUI/Console.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Console_Shown = false
		
# Input
func _input(event: InputEvent) -> void:
	# CAMERA
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * SENSITIVITY)
			$Camera3D.rotate_x(-event.relative.y * SENSITIVITY)
			$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)
	
	# Flashlight
	if Input.is_action_just_pressed("Flashlight"):
		if FlashlightOn == false and Is_Paused == false:
			print("Flashlight On")
			$Camera3D/Flashlight.light_energy = 7.0
			FlashlightOn = true
			$Sound/Flashlight.pitch_scale = 1.0
			$Sound/Flashlight.play()
		else:
			if Is_Paused == false:
				print("Flashlight Off")
				$Camera3D/Flashlight.light_energy = 0.0
				FlashlightOn = false
				$Sound/Flashlight.pitch_scale = 0.5
				$Sound/Flashlight.play()

	# Show player console
	if Input.is_action_just_pressed("Show Console"):
		if Console_Shown == false and Is_Paused == false:
			$PlayerUI/Console.show()
			Console_Shown = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Console_Shown == true and Is_Paused == false:
			$PlayerUI/Console.hide()
			Console_Shown = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Sprinting, walking, and crouching
	if Input.is_action_pressed("Sprint"):
		SPEED = SPRINT_SPEED
		$PlayerAnims.speed_scale = 1.5
	elif Input.is_action_pressed("Walk"):
		SPEED = WALK_SPEED
		$PlayerAnims.speed_scale = 0.5
	elif Input.is_action_pressed("Crouch") and Is_Paused == false:
		#$CollisionShape3D.scale.y = 0.23
		#$CollisionShape3D/MeshInstance3D.hide()
		#$PlayerAnims.speed_scale = 0.0
		$PlayerAnims.play("Uncrouch")
		SPEED = CROUCH_SPEED
	else:
		if Health > 0:
			if CAN_UNCROUCH == true:
				#$CollisionShape3D.scale.y = 1.0
				#$PlayerAnims.speed_scale = 1
				#$CollisionShape3D/MeshInstance3D.show()
				$PlayerAnims.play("Crouch")
				SPEED = 3.5
		else:
			SPEED = 0
			$PlayerAnims.speed_scale = 0
	
	# Pausing
	if Input.is_action_just_pressed("Pause"):
		if MouseModeJailed == true:
			if Has_Died == false:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				MouseModeJailed = false
				$PlayerUI/PauseMenu.show()
				Is_Paused = true
		else:
			if Has_Died == false:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				MouseModeJailed = true
				$PlayerUI/PauseMenu.hide()
				Is_Paused = false

# Player damage
func damaged(damageAmnt : int):
	if Health < 0:
		Health = 0
	
	if Health > 100:
		Health = 100
	
	Health -= damageAmnt
	$PlayerUI/GameBars/HealthBar.value = Health
	
	#$PlayerAnims.play("Hurt")
	
	if Health <= 0:
		PlayerDies()

# Player healing
func healed(healthAmnt : int):
	if Health > 100:
		Health = 100
	
	Health += healthAmnt
	$PlayerUI/GameBars/HealthBar.value = Health

# Player death
func PlayerDies():
	SPEED = 0.0
	WALK_SPEED = 0.0
	CROUCH_SPEED = 0.0
	SPRINT_SPEED = 0.0
	JUMP_VELOCITY = 0.0
	$Camera3D.position -= Vector3(0,-2,0)
	print("Player has died")
	Has_Died = true
	$PlayerUI/DebugGUI.hide()
	$PlayerUI/Console.hide()
	$PlayerUI/PauseMenu.hide()
	$PlayerUI/SettingsMenu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$".".velocity = Vector3(0,0,0)
	
	$PlayerUI/DeathMenu.show()

# Sensitivity setting
func _on_sensitivity_slider_value_changed(value: float) -> void:
	SENSITIVITY = $PlayerUI/SettingsMenu/SettingPanel/Vbox1/SensitivitySlider.value
	$PlayerUI/SettingsMenu/SettingPanel/Vbox1/SensLabel.text = "Sensitivity: " + str($PlayerUI/SettingsMenu/SettingPanel/Vbox1/SensitivitySlider.value*1000)

# Save game
func Save():
	var PlayerData = {
		"x": round(self.position.x),
		"y": round(self.position.y),
		"z": round(self.position.z),
		#"scene": Current_Scene
	}
	
	var jsonString = JSON.stringify(PlayerData)
	
	var jsonFile = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	jsonFile.store_line(jsonString)
	jsonFile.close()

#Load game
#This is slightly broken. You can load positions from other scenes.
func Load():
	var jsonFile = FileAccess.open("user://savegame.json", FileAccess.READ)
	var jsonString = jsonFile.get_as_text()
	jsonFile.close()
	
	var PlayerData = JSON.parse_string(jsonString)
	
	self.position.x = PlayerData.x
	self.position.y = PlayerData.y
	self.position.z = PlayerData.z
	#get_tree().change_scene_to_file(str(Current_Scene))
	

# Save game
func _on_save_game_pressed() -> void:
	Save()

# Load game
func _on_load_save_pressed() -> void:
	Load()

# Reload save
func _on_reload_save_pressed() -> void:
	Load()

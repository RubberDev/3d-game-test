extends Node3D

#var Lights = $Lights.get_children()
#var Lights = []
@export var Enabled : bool = true
@export var Default_Intensity : int = 1

#Set Enabled_Intensity to change a light's On value
@export var Enabled_Intensity : float = 1.0

# Upon starting the scene, if the light is on, make its intensity the same as Enabled_Intensity
func _ready() -> void:
	if Enabled == true:
		$Lights/Light1.light_energy = Enabled_Intensity

# Toggle light switch is player presses E while looking at it (Broken)
func Interact():
	if Enabled == true:
		$Lights/Light1.light_energy = 0
		Enabled = false
		$Animations.play("ToggleOff")
		$Sound/LightSwitchOff.play()
		print("Light off")
	elif Enabled == false:
		$Lights/Light1.light_energy = Enabled_Intensity
		Enabled = true
		$Animations.play("ToggleOn")
		$Sound/LightSwitchOn.play()
		print("Light on")

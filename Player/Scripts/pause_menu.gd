extends Control

func _ready() -> void:
	$MainP.hide()
	$Settings.hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused == false:
			$MainP.show()
			get_tree().paused = true
		else:
			$MainP.hide()
			$Settings.hide()
			get_tree().paused = false
	
	if Input.is_action_just_pressed("Pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Resume game, close pause menu
func _on_resume_pressed() -> void:
	get_tree().paused = false
	$MainP.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Quit game (Add confirmation later maybe)
func _on_quit_pressed() -> void:
	get_tree().quit()

# Settings button
func _on_settings_pressed() -> void:
	$Settings.show()

# Volume
var bus = AudioServer.get_bus_index("Master")
func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	$Settings/VBoxContainer/VolumeLabel.text = "Volume: " + str(value*100)

extends Control

var save_path = "user://settingsInfo.save"

func _ready() -> void:
	$MainP.hide()
	$Settings.hide()
	load_info()
	

# Pausing
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

# Close settings
func _on_close_settings_pressed() -> void:
	$Settings.hide()

# Quit to the debug menu
func _on_quit_2_debug_pressed() -> void:
	get_tree().change_scene_to_file("res://TitleScreens/DebugTitleScr/DebugTitleScreen.tscn")

# Save everything in the settings menu (Debug only)
func _on_save_settings_debug_pressed() -> void:
	save_info()

# Load everything in the settings menu (Debug only)
func _on_load_settings_debug_pressed() -> void:
	load_info()



# Volume
var bus = AudioServer.get_bus_index("Master")
func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	$Settings/VBoxContainer/VolumeLabel.text = "Volume: " + str(value)
	save_info()

# Window modes
func _on_window_modes_item_selected(index: int) -> void:
	save_info()
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

# Anti-aliasing
func _on_atni_aliasing_item_selected(index: int) -> void:
	save_info()
	match index:
		0:
			get_viewport().msaa_3d = Viewport.MSAA_8X
			get_viewport().use_taa = false
		1:
			get_viewport().msaa_3d = Viewport.MSAA_4X
			get_viewport().use_taa = false
		2:
			get_viewport().msaa_3d = Viewport.MSAA_2X
			get_viewport().use_taa = false
		3:
			get_viewport().use_taa = true
		4:
			get_viewport().msaa_3d = Viewport.MSAA_DISABLED
			get_viewport().use_taa = false

# Shadow resolution
func _on_shadow_quality_item_selected(index: int) -> void:
	save_info()
	match index:
		0:
			RenderingServer.directional_shadow_atlas_set_size(8192, true)
		1:
			RenderingServer.directional_shadow_atlas_set_size(4096, true)
		2:
			RenderingServer.directional_shadow_atlas_set_size(2048, true)
		3:
			RenderingServer.directional_shadow_atlas_set_size(1024, true)

# Scaling
func _on_scaling_item_selected(index: int) -> void:
	save_info()
	match index:
		0:
			RenderingServer.viewport_set_scaling_3d_mode(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2)
		1:
			RenderingServer.viewport_set_scaling_3d_mode(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR)
		2:
			RenderingServer.viewport_set_scaling_3d_mode(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCALING_3D_MODE_BILINEAR)

# Save and load settings (Does not apply to everything)
func save_info():
	# Oh this'll be fun, I can tell
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	file.store_var(AudioServer.get_bus_volume_db(bus), true)
	file.store_var(DisplayServer.window_get_mode(), true)
	file.store_var(get_viewport().msaa_3d, true)
	file.store_var(get_viewport().use_taa, true)
	file.store_var($Settings/VBoxContainer/Volume.value)
	# Viewport scaling here
	# Shadow atlas size here

func load_info():
	print("Test")
	if FileAccess.file_exists(save_path):
		var file := FileAccess.open(save_path, FileAccess.READ)
		
		if file == null:
			push_error("Failed to open settings save file for reading: " + save_path)
			return
			
		print(" --- Load Info --- ")
		
		var bus_volume_db = file.get_var()
		print("Bus volume (dB): ", bus_volume_db)
		AudioServer.set_bus_volume_db(bus, bus_volume_db)
		
		var window_mode = file.get_var()
		print("Window mode: " + str(window_mode))
		DisplayServer.window_set_mode(window_mode)
		
		var anti_aliasing = file.get_var()
		print("Anti-Aliasing: " + str(anti_aliasing))
		get_viewport().msaa_3d = anti_aliasing
		
		var use_taa = file.get_var()
		print("Using TAA: " + str(use_taa))
		get_viewport().use_taa = use_taa
		
		var volume_slide = file.get_var()
		print("Volume slider " + str(volume_slide))
		$Settings/VBoxContainer/Volume.value = volume_slide
		
		print(" --- End --- ")
		
	elif not FileAccess.file_exists(save_path):
		push_error("Settings save file does not exist: " + save_path)

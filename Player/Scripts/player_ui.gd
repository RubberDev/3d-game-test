extends Control

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	# Debug GUI
	$DebugGUI/VBoxContainer/FPS_Count.text = "FPS: " + str(Engine.get_frames_per_second())
	$DebugGUI/VBoxContainer/Player_Speed.text = "Speed: " + str($"..".SPEED)
	$DebugGUI/VBoxContainer/RAM_Usage.text = "RAM Use: " + str(OS.get_static_memory_usage())
	$DebugGUI/VBoxContainer/RAM_Peak_Use.text = "RAM Peak: " + str(OS.get_static_memory_peak_usage())
	$DebugGUI/VBoxContainer/CPU_Threads.text = "Processor Threads: " + str(OS.get_processor_count())
	$DebugGUI/VBoxContainer/CPU_Name.text = "Processor Model: " + str(OS.get_processor_name())
	
	
	
func _unhandled_input(event: InputEvent) -> void:
	# This is also part of the debug GUI
	if event is InputEventKey:
		$DebugGUI/VBoxContainer/Key_Press.text = "Key: %s" % event.as_text_key_label()

func _on_line_edit_text_submitted(new_text: String) -> void:
	# This puts the text entered from the ConsoleInput into the ConsoleOutput
	$Console/ConsoleBG/OutputBG/ConsoleOutput.text += str("\n" + $Console/ConsoleBG/ConsoleInput.text)
	
	# Console commands
	# There is probably a better way to do this
	
	# Debugging commands
	if new_text == "Show Debug_Menu":
		$DebugGUI.show()
	elif new_text == "Hide Debug_Menu":
		$DebugGUI.hide()
		
	if new_text == "Quit":
		get_tree().quit()
	
	if new_text == "Kill":
		$"..".damaged(100)
	
	else:
		$Console/ConsoleBG/OutputBG/ConsoleOutput.text += str("\n" + "]")


# Pause menu
var Paused: bool = false
func _on_resume_pressed() -> void:
	$PauseMenu.hide()
	self.get_parent().Is_Paused = false
	Paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_settings_pressed() -> void:
	if Settings_Shown == false:
		$SettingsMenu.show()
		Settings_Shown = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_close_settings_pressed() -> void:
	$SettingsMenu.hide()
	#$PauseMenu.hide()
	Settings_Shown = false
	#Paused = false
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_quit_2_debug_pressed() -> void:
	get_tree().change_scene_to_file("res://TitleScreens/DebugTitleScr/DebugTitleScreen.tscn")


# Settings Menu
var Settings_Shown : bool = false

# Volume
func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value/5)

# Resolution (Doesn't work properly)
func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2(1440,900))
		1:
			DisplayServer.window_set_size(Vector2(1920,1080))
		2:
			DisplayServer.window_set_size(Vector2(1280,800))
		3:
			DisplayServer.window_set_size(Vector2(1280,720))
		4:
			DisplayServer.window_set_size(Vector2(854,480))

# Anti-Aliasing
func _on_anti_alias_options_item_selected(index: int) -> void:
	match index:
		0:
			get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		1:
			get_viewport().msaa_3d = Viewport.MSAA_2X
		2:
			get_viewport().msaa_3d = Viewport.MSAA_4X
		3:
			get_viewport().msaa_3d = Viewport.MSAA_8X

# Use TAA
func _on_use_taa_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_viewport().use_taa = true
	else:
		get_viewport().use_taa = false

# Fullscreen
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		$SettingsMenu/SettingPanel/Vbox1/WindBrdrless.set_deferred("disabled", true)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$SettingsMenu/SettingPanel/Vbox1/WindBrdrless.set_deferred("disabled", false)

# Windowed Borderless
func _on_wind_brdrless_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$SettingsMenu/SettingPanel/Vbox1/Fullscreen.set_deferred("disabled", true)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$SettingsMenu/SettingPanel/Vbox1/Fullscreen.set_deferred("disabled", false)

# Death Menu
func _on_restart_level_pressed() -> void:
	get_tree().reload_current_scene()

# FOVLabel
func _on_fov_label_2_value_changed(value: float) -> void:
	$"../Camera3D".fov = $SettingsMenu/SettingPanel/Vbox1/FOVLabel2.value
	$SettingsMenu/SettingPanel/Vbox1/FOVLabel.text = "FOV: " + str($SettingsMenu/SettingPanel/Vbox1/FOVLabel2.value)

# FOV reset
func _on_reset_fo_vbutton_pressed() -> void:
	$"../Camera3D".fov = 75
	$SettingsMenu/SettingPanel/Vbox1/FOVLabel2.value = 75
	$SettingsMenu/SettingPanel/Vbox1/FOVLabel.text = "FOV: " + str($SettingsMenu/SettingPanel/Vbox1/FOVLabel2.value)

# Shadow resolution
func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
		1:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		2:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		3:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		4:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
		5:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)

# Use debanding
func _on_use_deband_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_viewport().use_debanding = true
	else:
		get_viewport().use_debanding = false

func _on_quit_game_pressed() -> void:
	get_tree().quit()

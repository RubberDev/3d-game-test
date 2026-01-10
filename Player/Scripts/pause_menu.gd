extends Control

func _ready() -> void:
	self.hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused == false:
			self.show()
			get_tree().paused = true
		else:
			self.hide()
			get_tree().paused = false

# Resume game, close pause menu
func _on_resume_pressed() -> void:
	get_tree().paused = false
	self.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Quit game (Add confirmation later maybe)
func _on_quit_pressed() -> void:
	get_tree().quit()

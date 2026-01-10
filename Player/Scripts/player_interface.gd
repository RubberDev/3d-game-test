extends CanvasLayer


func _ready() -> void:
	$Attributes/StaminaBar.hide()


func _process(_delta: float) -> void:
	if Input.is_action_pressed("Sprint"):
		$Attributes/StaminaBar.value -= 0.1
	else:
		$Attributes/StaminaBar.value += 0.1

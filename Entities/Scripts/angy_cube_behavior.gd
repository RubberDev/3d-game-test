extends Area3D
class_name AngyCube
@export var CUBE_DMG : int
@export var DEBUG_ENABLED : bool
@export var DMG_OVER_TIME : bool = false

func _ready() -> void:
	if DEBUG_ENABLED == true:
		$DebugMesh.show()
	else:
		$DebugMesh.hide()
	
	$Timer.start()

# Damage player as they touch cube
func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		if DMG_OVER_TIME == false:
			print("Angy Cube >:3")
			body.damage(CUBE_DMG)
			print(body.Health)
		elif DMG_OVER_TIME == true:
			_on_timer_timeout()

# Damage the player every time the timer resets
func _on_timer_timeout() -> void:
	for body in get_overlapping_bodies():
		if body is Player:
			if DMG_OVER_TIME == true:
				body.damage(CUBE_DMG)

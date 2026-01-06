extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Environment/DirectionalLight3D.hide()

# Delete the key and the door located in the room at the beginning of the level
func _on_lvl_5_door_1_key_body_entered(_body: Node3D) -> void:
	$LevelGeometry/Room1/PzlDoor1.queue_free()
	$LvlObjs/Lvl5Door1Key.queue_free()

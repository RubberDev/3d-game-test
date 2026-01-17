extends StaticBody3D

@export var Locked : bool
var Opened : bool = false
@export var Referencing : bool = false

func _ready() -> void:
	if Referencing == true:
		$RotationPoint/MeshInstance3D/Label3D.show()
	else:
		$RotationPoint/MeshInstance3D/Label3D.hide()

# When player presses E while looking at door, open/close the door
# I don't care how fucked this is, it works
func Interact():
		if Locked == false:
			if Opened == false:
				$AnimationPlayer.play("OpenDoor")
				$Sound/DoorOpen.play()
				$LockedCollider.set_deferred("disabled", true)
				$LockedCollider2.set_deferred("disabled", false)
				Opened = true
			elif Opened == true:
				$AnimationPlayer.play("CloseDoor")
				$Sound/DoorClose.play()
				$LockedCollider.set_deferred("disabled", false)
				$LockedCollider2.set_deferred("disabled", true)
				Opened = false
		if Locked == true:
			if Opened == false:
				$AnimationPlayer.play("Locked")
				$Sound/LockedWoodDoor.play()
				$LockedCollider.set_deferred("disabled", false)
				$LockedCollider2.set_deferred("disabled", true)

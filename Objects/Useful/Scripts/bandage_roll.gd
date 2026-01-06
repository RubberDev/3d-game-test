extends Node3D
var Usable := true

# When the player enters the Area3D of the node, add 10 health to the play, play the sound
# then hide itself
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		if body.Health < 100:
			if Usable == true:
				body.healed(10)
				$SFX/UseBandages.play()
				self.hide()
			else:
				pass
		else:
			pass

# Delete itself once the sound finishes
func _on_use_bandages_finished() -> void:
	queue_free()

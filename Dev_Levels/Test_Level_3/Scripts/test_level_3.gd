extends Node3D

# I should make this into a scene. The light and Area3D in the same scene. When the
# Player enters the Area3D, instead of calling for each individual light, it calls all children
# Of the scene, which makes it easier to add more lights

func _on_light_switch_body_entered(body: Node3D) -> void:
	if body is Player:
		$Geometry/BaseRoom/Lights/BaseRoomLight1.light_energy = 0

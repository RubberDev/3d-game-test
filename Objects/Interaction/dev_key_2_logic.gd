extends TestLevel1

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		print("Player collected key")
		DevKey2Collected = true
		print(DevKey2Collected)

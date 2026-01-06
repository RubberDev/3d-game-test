extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		_on_timer_timeout()


func _on_timer_timeout() -> void:
	for body in get_overlapping_bodies():
		if body is Player:
			body.damaged(5)
			if body.Health > 0:
				$Burnt.pitch_scale = randf_range(0.8,1.2)
				$Burnt.play()

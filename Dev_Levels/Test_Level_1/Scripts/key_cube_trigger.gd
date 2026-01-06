extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


var OpenMat = preload("res://Materials/1 Debug/KeyTestOpen.tres")

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		$"../KeyCube".set_surface_override_material(0, OpenMat)

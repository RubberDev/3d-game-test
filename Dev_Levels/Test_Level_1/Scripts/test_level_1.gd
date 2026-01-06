class_name TestLevel1
extends Node3D

@export var DevKey2Collected: bool = false
var OpenMat = preload("res://Materials/1 Debug/KeyTestOpen.tres")
var ClosedMat = preload("res://Materials/1 Debug/KeyTestClosed.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#if DevKey2Collected == true:
		#$"../KeyCube".set_surface_override_material(0, OpenMat)
	#else:
		#$"../KeyCube".set_surface_override_material(0, ClosedMat)

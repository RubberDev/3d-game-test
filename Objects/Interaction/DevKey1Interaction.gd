extends Node

@export var Active: bool = true

func _interaction():
	queue_free()

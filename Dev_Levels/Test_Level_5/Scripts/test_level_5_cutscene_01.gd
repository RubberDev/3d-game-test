extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CutsceneTest1/AnimationPlayer2.play("Cube_004Action")
	$CutsceneTest1/AnimationPlayer3.play("male01Action")
	$Camera3D/AnimationPlayer.play("FallAnim")
	
	
# I'm gonna be honest I have no fucking clue how this works
func _on_animation_player_2_animation_finished(_anim_name: StringName) -> void:
	$SFX/DoorSlam.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Dev_Levels/Test_Level_5/test_level_5.tscn")

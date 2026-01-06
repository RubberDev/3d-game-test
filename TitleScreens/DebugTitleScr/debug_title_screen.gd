extends Control
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_tst_lvl_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Dev_Levels/Test_Level_1/test_level_1.tscn")


func _on_test_lvl_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Dev_Levels/Test_Level_2/test_level_2.tscn")


func _on_test_lvl_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Dev_Levels/Test_Level_3/test_level_3.tscn")


func _on_test_lvl_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Dev_Levels/Test_Level_4/test_level_4.tscn")


func _on_test_lvl_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Dev_Levels/Test_Level_5/test_level_5_cutscene_01.tscn")


func _on_test_lvl_6_pressed() -> void:
	get_tree().change_scene_to_file("res://Dev_Levels/Test_Level_6/door_test_1.tscn")


func _on_test_lvl_7_pressed() -> void:
	get_tree().change_scene_to_file("res://Dev_Levels/Misc_Tests/kill_yourself.tscn")


func _on_particle_room_pressed() -> void:
	get_tree().change_scene_to_file("res://Dev_Levels/Test_Level_7/particles.tscn")


func _on_blender_import_test_pressed() -> void:
	get_tree().change_scene_to_file("res://Dev_Levels/Test_Level_9/blebder.tscn")

extends Control

func _on_OK_pressed():
	Global.purchased = true
	get_tree().change_scene_to_file("res://Main/Main.tscn")
	return

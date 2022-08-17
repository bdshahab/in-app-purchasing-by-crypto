extends Control

func _on_OK_pressed():
	Global.purchased = true
	var _s = get_tree().change_scene("res://Main/Main.tscn")
	return

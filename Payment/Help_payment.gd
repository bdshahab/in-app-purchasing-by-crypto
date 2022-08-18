extends Control

func _on_Back_pressed():
	var _s = get_tree().change_scene("res://Payment/Payment.tscn")
	queue_free()

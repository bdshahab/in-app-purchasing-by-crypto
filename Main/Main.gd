extends Control

func _on_Pay_Button_pressed():
	var _s = get_tree().change_scene("res://Payment/Payment.tscn")

func _on_About_Button_pressed():
	var _s = get_tree().change_scene("res://About/about.tscn")

func _on_Exit_Button_pressed():
	get_tree().quit()

func _on_Main_visibility_changed():
	$Purchase_Button.disabled = not Global.purchased

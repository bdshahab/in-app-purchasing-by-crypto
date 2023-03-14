extends Control

var http_request: HTTPRequest

func _ready():
	Global.OS_name = OS.get_name()
	OS.low_processor_usage_mode = OS.get_name() != "Android"
	get_window().mode = Window.MODE_MAXIMIZED if (true) else Window.MODE_WINDOWED
	# This is for MAC OS and HTML not other OSs!
#	DisplayServer.set_native_icon("res://Icon.png")

func _on_Pay_Button_pressed():
	get_tree().change_scene_to_file("res://Payment/Payment.tscn")

func _on_About_Button_pressed():
	get_tree().change_scene_to_file("res://About/about.tscn")

func _on_Exit_Button_pressed():
	get_tree().quit()

func _on_Main_visibility_changed():
	$Purchase_Button.disabled = not Global.purchased

extends Control

func _on_OK_pressed() -> void:
	var _s = get_tree().change_scene("res://Main/Main.tscn")

func _on_blogger_pressed() -> void:
	var _s = OS.shell_open("http://bdshahab.blogspot.com")

func _on_facebook_pressed() -> void:
	var _s = OS.shell_open("https://www.facebook.com/shahab.baradaran.dilmaghani")

func _on_instagram_pressed() -> void:
	var _s = OS.shell_open("https://www.instagram.com/bdshahab1982")

func _on_twitter_pressed() -> void:
	var _s = OS.shell_open("https://twitter.com/bdshahab")

extends Control

# android screen flicker
#func _process(_delta):
#	if General.OS_name != "Android":
#		return
#	for i in get_children():
#		i.update()

func _on_OK_pressed() -> void:
	var _s = get_tree().change_scene("res://Main/Main.tscn")

func _on_license_pressed() -> void:
	var _s = OS.shell_open("https://creativecommons.org/licenses/by/4.0")

func _on_blogger_pressed() -> void:
	var _s = OS.shell_open($social_media/hb1/blogger.hint_tooltip)

func _on_diaspora_pressed() -> void:
	var _s = OS.shell_open($social_media/hb1/diaspora.hint_tooltip)

func _on_facebook_pressed() -> void:
	var _s = OS.shell_open($social_media/hb1/facebook.hint_tooltip)

func _on_flickr_pressed() -> void:
	var _s = OS.shell_open($social_media/hb1/flickr.hint_tooltip)

func _on_instagram_pressed() -> void:
	var _s = OS.shell_open($social_media/hb1/instagram.hint_tooltip)

func _on_linkedin_pressed() -> void:
	var _s = OS.shell_open($social_media/hb1/linkedin.hint_tooltip)

func _on_livejournal_pressed() -> void:
	var _s = OS.shell_open($social_media/hb2/livejournal.hint_tooltip)

func _on_medium_pressed() -> void:
	var _s = OS.shell_open($social_media/hb2/medium.hint_tooltip)

func _on_pinterest_pressed() -> void:
	var _s = OS.shell_open($social_media/hb2/pinterest.hint_tooltip)

func _on_telegram_pressed() -> void:
	var _s = OS.shell_open($social_media/hb3/telegram.hint_tooltip)

func _on_tumblr_pressed() -> void:
	var _s = OS.shell_open($social_media/hb3/tumblr.hint_tooltip)

func _on_twitter_pressed() -> void:
	var _s = OS.shell_open($social_media/hb3/twitter.hint_tooltip)

func _on_vk_pressed() -> void:
	var _s = OS.shell_open($social_media/hb3/vk.hint_tooltip)

func _on_youtube_pressed() -> void:
	var _s = OS.shell_open($social_media/hb3/youtube.hint_tooltip)

func _on_gab_pressed() -> void:
	var _s = OS.shell_open($social_media/hb1/gab.hint_tooltip)

func _on_wordpress_pressed() -> void:
	var _s = OS.shell_open($social_media/hb3/wordpress.hint_tooltip)

func _on_reddit_pressed() -> void:
	var _s = OS.shell_open($social_media/hb2/reddit.hint_tooltip)

func _on_mastodon_pressed():
	var _s = OS.shell_open($social_media/hb2/mastodon.hint_tooltip)

func _on_flipboard_pressed():
	var _s = OS.shell_open($social_media/hb1/flipboard.hint_tooltip)

func _on_imgur_pressed():
	var _s = OS.shell_open($social_media/hb1/imgur.hint_tooltip)

func _on_matrix_pressed():
	var _s = OS.shell_open($social_media/hb2/matrix.hint_tooltip)

func _on_mewe_pressed():
	var _s = OS.shell_open($social_media/hb2/mewe.hint_tooltip)

func _on_parler_pressed():
	var _s = OS.shell_open($social_media/hb2/parler.hint_tooltip)

func _on_rumble_pressed():
	var _s = OS.shell_open($social_media/hb2/rumble.hint_tooltip)

func _on_steemit_pressed():
	var _s = OS.shell_open($social_media/hb3/steemit.hint_tooltip)

func _on_tiktok_pressed():
	var _s = OS.shell_open($social_media/hb3/tiktok.hint_tooltip)

func _on_spreely_pressed():
	var _s = OS.shell_open($social_media/hb3/spreely.hint_tooltip)

func _on_the_dots_pressed():
	var _s = OS.shell_open($social_media/hb3/the_dots.hint_tooltip)

func _on_about_me_pressed():
	var _s = OS.shell_open($about_me.hint_tooltip)

func _on_minds_pressed():
	var _s = OS.shell_open($social_media/hb2/minds.hint_tooltip)

func _on_flote_pressed():
	var _s = OS.shell_open($social_media/hb1/flote.hint_tooltip)

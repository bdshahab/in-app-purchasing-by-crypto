extends Control
#User only have limited time(for example: 10 min)
#to register payment. Otherwise, it will be close.
#
#1. User picks the method pay
#2. app show the price in that currency and register date of today and tomorrow
#3.User have to send exact that amount of money to the bdshahab address.
#4. User have to register payment TXID in limited time.
#5. app verify the payment with registered price in that time
#price check by https://www.livecoinwatch.com

#price
#<span class="price">$
#tomorrow date
#priceValidUntil":"
#time now
#"lastSeen":"
#time now saves in this variable:
#time1_price_checked

const APP_PRICE_A_DAY_IN_DOLLAR : float = 0.01
const PAYMENTLIST_INIT_SELECTED : int = 3
const MINIMUM_LIMIT_PRICE : float = 0.00000001
const disable_color : String = "803f3f3f"
const enable_color : String = "c40bff"
const INIT_TIME_TEXT : String = "10 : 00"
const FINISHED_TIME_TEXT : String = "00 : 00"
const RED_COLOR : String = "ff0000"
const GREEN_COLOR : String = "00ff00"
const BLUE_COLOR : String = "0000ff"

const MAX_TIME_OF_PAYMENT : int = 600
var time_of_payment : int = MAX_TIME_OF_PAYMENT

var web_content : String = ""
var web_content_price : String = ""
var txid : String = ""
var time1_price_checked : String = ""
var time2_payment_registered : String = ""
var day_changed : bool = false
var init_time_register : String = ""
var final_time_register : String = ""
var my_wallet_address_to_receive_money : String = ""
var value_of_money : String = ""
var date_today : String = ""
var date_tomorrow : String = ""
var http_request: HTTPRequest
var txid_error := false
var price_error := false
var final_body_content
var final_body_content_price
var verify_clicked = false

# 14 currency methods
# name of currency / price check site / wallet address / verify site / Icon
# all of the verify site are same as each other which guarda uses.
const pay_list = [
	["Bitcoin (BTC)", "https://www.livecoinwatch.com/price/Bitcoin-BTC", "1LQSzFZKE5vwiUS94toMG7r5M2nQ4X2muw", "https://bitcoinblockexplorers.com/tx/", "res://Payment/Photos/bitcoin (btc).png"],
	["Bitcoin Cash (BCH)", "https://www.livecoinwatch.com/price/BitcoinCash-BCH", "bitcoincash:qzhr6lc9r64c3wg3jnndqaxzpyxeghdp2s57w5wgwu", "https://bchblockexplorer.com/tx/", "res://Payment/Photos/bitcoin cash (bch).png"],
	["Bitcoin Gold (BTG)", "https://www.livecoinwatch.com/price/BitcoinGold-BTG", "GJbYu4YviyCi8azMV6ZAvdhjJTcigdmnPV", "https://btgexplorer.com/tx/", "res://Payment/Photos/bitcoin gold (btg).png"],
	["Dash (DASH)", "https://www.livecoinwatch.com/price/Dash-DASH", "Xn5HwktiWJfgKydTDjodBTjJDA6tVxzAho", "https://dashblockexplorer.com/tx/", "res://Payment/Photos/dash (dash).png"],
	["DigiByte (DGB)", "https://www.livecoinwatch.com/price/DigiByte-DGB", "D97CQ5pV1AukRY1FJTSW3CFkJtUZgdwJq4", "https://digibyteblockexplorer.com/tx/", "res://Payment/Photos/digibyte (dgb).png"],
	["Dogecoin (DOGE)", "https://www.livecoinwatch.com/price/Dogecoin-DOGE", "D5YP7CggUUkS3fu1B7RjhjJ7jvNu6A4Ksx", "https://dogeblocks.com/tx/", "res://Payment/Photos/dogecoin (doge).png"],
	["Ethereum (ETH)", "https://www.livecoinwatch.com/price/Ethereum-ETH", "0x80D3CA7528cF05118131dBa3d7852Db2685c4b9E", "https://ethblockexplorer.org/tx/", "res://Payment/Photos/ethereum (eth).png"],
	["FIRO (FIRO)", "https://www.livecoinwatch.com/price/FIRO-FIRO", "a5R3Z4XBjj9oQS6kMgtfT5kMYMnA8Qx2Ga", "https://firoblockexplorers.com/tx/", "res://Payment/Photos/firo (firo).png"],
	["Komodo (KMD)", "https://www.livecoinwatch.com/price/Komodo-KMD", "RQzp2jDRhRMrzBJZobGtUQhkQfcnfXdxWz", "https://komodoblockexplorer.com/tx/", "res://Payment/Photos/komodo (kmd).png"],
	["Litecoin (LTC)", "https://www.livecoinwatch.com/price/Litecoin-LTC", "LRQ6TBVXsEVPApbCY79bV1d9LR8E7JiuDd", "https://litecoinblockexplorer.net/tx/", "res://Payment/Photos/litecoin (ltc).png"],
	["Qtum (QTUM)", "https://www.livecoinwatch.com/price/Qtum-QTUM", "QXFD7QitfegWXf4n4F9bVLU9HXqESgRVWq", "https://qtumblockexplorer.com/tx/", "res://Payment/Photos/qtum (qtum).png"],
	["Ravencoin (RVN)", "https://www.livecoinwatch.com/price/Ravencoin-RVN", "RLMJbB268ayzGtJokjimNiLgdAccF8yv21", "https://rvnblockexplorer.com/tx/", "res://Payment/Photos/ravencoin (rvn).png"],
	["ReddCoin (RDD)", "https://www.livecoinwatch.com/price/ReddCoin-RDD", "RvawiN6Ues4gxdu52JkKLQ7cKYSDDYwkUQ", "https://rddblockexplorer.com/tx/", "res://Payment/Photos/reddcoin (rdd).png"],
	["Verge (XVG)", "https://www.livecoinwatch.com/price/Verge-XVG", "DKY9rZfiw6qShLvWzKZCmuKJdiadDyhnVr", "https://xvgblockexplorer.com/tx/", "res://Payment/Photos/verge (xvg).png"],
	["Vertcoin (VTC)", "https://www.livecoinwatch.com/price/Vertcoin-VTC", "VmLS1YQuRVJT73ZkQyQNKWUPUCEsC95MSJ", "https://vtcblocks.com/tx/", "res://Payment/Photos/vertcoin (vtc).png"],
	["Zcash (ZEC)", "https://www.livecoinwatch.com/price/Zcash-ZEC", "t1gFJup6Mri4mZ1Pgqgzqmz2a3hg66Cpyga", "https://zecblockexplorer.com/tx/", "res://Payment/Photos/zcash (zec).png"],
]

func _ready():
	for i in range(pay_list.size()):
		$paymentList.add_item(pay_list[i][0])
	$paymentList.selected = PAYMENTLIST_INIT_SELECTED
	set_currency_logo(PAYMENTLIST_INIT_SELECTED)
	$txid.text = ""
	$wallet_address.text = pay_list[$paymentList.selected][2]
	$currency_logo.texture_normal = load(pay_list[$paymentList.selected][4])
	reset_time()
	http_request = HTTPRequest.new()
	add_child(http_request)
	txid_error = false
	price_error = false
	http_request.connect("request_completed",Callable(self,"_on_HTTPRequest_request_completed"))
	first_http_call()
	$currency_logo.tooltip_text = $paymentList.text

func first_http_call():
	var error = http_request.request(pay_list[$paymentList.selected][1])
	if error != OK:
		$netDialog.show()
		return
	$paymentList.disabled = true
	$HBoxContainer/Verify.disabled = true
	$HBoxContainer/Verify.self_modulate = disable_color

func reset_time():
	$Label_time.text = INIT_TIME_TEXT
	time_of_payment = MAX_TIME_OF_PAYMENT
	$Label_time.self_modulate = GREEN_COLOR

func set_remaining_time():
	if time_of_payment <= 0:
		$Label_time.text = FINISHED_TIME_TEXT
		return
	var sec = time_of_payment % 60
	var minute = (time_of_payment - sec) / 60
	if sec < 10:
		sec = "0" + str(sec)
	if minute < 10:
		minute = "0" + str(minute)
	var output = str(minute) + " : " + str(sec)
	$Label_time.text = output

func change_date_format(date: String):
	var splitted = date.split("-")
	if splitted.size() != 3:
		return date
	var year = splitted[0]
	var month = splitted[1]
	var day = splitted[2]
	match(month):
		'01': month = 'Jan'
		'02': month = 'Feb'
		'03': month = 'Mar'
		'04': month = 'Apr'
		'05': month = 'May'
		'06': month = 'Jun'
		'07': month = 'Jul'
		'08': month = 'Aug'
		'09': month = 'Sep'
		'10': month = 'Oct'
		'11': month = 'Nov'
		'12': month = 'Dec'
	return day + " " + month + " " + year

func _on_Timer_timeout():
	time_of_payment -= 1
	if time_of_payment < 180:
		$Label_time.self_modulate = RED_COLOR
	elif time_of_payment < 360:
		$Label_time.self_modulate = BLUE_COLOR
	else:
		$Label_time.self_modulate = GREEN_COLOR
	set_remaining_time()
	if time_of_payment <= 0:
		$HBoxContainer/Verify.disabled = true
		$HBoxContainer/Verify.self_modulate = disable_color
		$Timer.stop()
		time_of_payment = 0
		get_tree().change_scene_to_file("res://Main/Main.tscn")

func _on_Verify_pressed():
	$paymentList.disabled = true
	$paymentList.self_modulate = "#1FFF72"
	if not verify_clicked:
		var error = $HTTPRequest2.request(pay_list[$paymentList.selected][3] + $txid.text)
		if error != OK:
			$netDialog.show()
			return
	else:
		http_request.cancel_request()
		first_http_call()
		$HTTPRequest2.cancel_request()
		verify_clicked = false
		txid_error = false
		price_error = false
		var error = $HTTPRequest2.request(pay_list[$paymentList.selected][3] + $txid.text)
		if error != OK:
			$netDialog.show()
			return
#	verify_clicked = true
	$HBoxContainer/Verify.disabled = true
	$HBoxContainer/Verify.self_modulate = disable_color

func _on_HTTPRequest_request_completed(_result, _response_code, _headers, _body):
	# for manually exception handling!
	final_body_content_price = _body
	
	if txid_error:
		return
	if _result != 0 or _body.size() < time_of_payment:
		$netDialog.show()
		return
	else:
		checking_price()

func checking_price():
	if price_error:
		return
	var content = final_body_content_price.get_string_from_utf8()
	web_content_price = content
	var array = web_content_price.find("lastSeen\":\"")
	if not txid_error and (web_content_price.length() < MAX_TIME_OF_PAYMENT):
		$netDialog.show()
		return
	elif array == -1:
		$netDialog.show()
		return
	elif not verify_clicked:
		date_today = web_content_price.substr(array + 11, 10)
		var text1 = content.split("priceValidUntil", true)
		if text1.size() < 2:
			$netDialog.show()
			return
		text1 = text1[1].split("offerCount", true)[0]
		var today_array = text1.split("\"", true)
		if today_array.size() < 3:
			$netDialog.show()
			return
		text1 = today_array[2]
		
		var date_tomorrow_array = text1.split("T", true)
		if date_tomorrow_array.size() < 2:
			$netDialog.show()
			return
		date_tomorrow = date_tomorrow_array[0]
		var time_array = text1.split("T", true)
		if time_array.size() < 2:
			$netDialog.show()
			return
		time1_price_checked = time_array[1]
		time_array = time1_price_checked.split(".", true)
		if time_array.size() < 2:
			$netDialog.show()
			return
		time1_price_checked = time_array[0]
		init_time_register = ""
		final_time_register = ""
		init_time_register = time1_price_checked

		var splitted = content.split("<span class=\"price\">$", true)
		if splitted.size() < 2:
			$netDialog.show()
			return
		var text2 = splitted[1].split("</span>", true)
		if text2.size() < 2:
			$netDialog.show()
			return
		var crypto_in_dollar = float(text2[0])
		var date_valid_price_array = content.split("priceValidUntil\":\"", true)
		if date_valid_price_array.size() < 2:
			$netDialog.show()
			return
		var date_valid_price = date_valid_price_array[1]
		var user_price = APP_PRICE_A_DAY_IN_DOLLAR / crypto_in_dollar
		if user_price < MINIMUM_LIMIT_PRICE:
			$priceDialog.show()
			return
		else:
			user_price = "%.8f" % user_price
			$price.text = user_price
			value_of_money = user_price
			date_tomorrow = date_valid_price.substr(0, 10)
			my_wallet_address_to_receive_money = pay_list[$paymentList.selected][2]
			txid = $txid.text
		_on_txid_text_changed(txid)
		$paymentList.disabled = false
		reset_time()
		$Timer.start()

# This method checks the receipt of the payment site like this:
# https://litecoinblockexplorer.net/tx/61a7667851da2d1395c26f4eaba7a14a3c1355ba80e1b35678327619a115d21e
func verify_payment():
	if txid_error:
		return
	
	txid = $txid.text
	# uncomment to test if this program works correctly (for Litecoin)
#	txid = "61a7667851da2d1395c26f4eaba7a14a3c1355ba80e1b35678327619a115d21e"
#	value_of_money = "0.00994188"
#	date_today = "08 Feb 2022"
#	time1_price_checked = "07:00:47"
#	time2_payment_registered = "07:05:47"
	date_today = change_date_format(date_today)
	date_tomorrow = change_date_format(date_tomorrow)
	var bought_it = false
	var date_passed = true
	var time_passed = true
	if txid in web_content:
		if my_wallet_address_to_receive_money in web_content:
			if value_of_money in web_content:
				if (date_today in web_content) or (date_tomorrow in web_content):
					if check_time(time2_payment_registered) and compare_times(time1_price_checked, time2_payment_registered):
						if day_changed:
							if (date_tomorrow in web_content):
								bought_it = true
							else:
								date_passed = false
						else:
							if (date_today in web_content):
								bought_it = true
							else:
								date_passed = false
					else:
						time_passed = false
				else:
					date_passed = false
	if bought_it:
		# if you buy it successfully
		get_tree().change_scene_to_file("res://Payment/You_Bought_this.tscn")
		return
	else:
		if not time_passed:
			$timeDialog.show()
		elif not date_passed:
			$dateDialog.show()
		else:
			$txidDialog.show()

func _on_paymentList_item_selected(id):
	if verify_clicked:
		$paymentList.disabled = true
		return
	$currency_logo.tooltip_text = $paymentList.text
	price_error = false
	$Timer.stop()
	reset_time()
	$paymentList.disabled = true
	$HBoxContainer/Verify.disabled = true
	$HBoxContainer/Verify.self_modulate = disable_color
	$price.text = ""
	$wallet_address.text = pay_list[id][2]
	var error = http_request.request(pay_list[id][1])
	if error != OK:
		$netDialog.show()
		return
	set_currency_logo(id)

func set_currency_logo(id):
	$currency_logo.texture_normal = load(pay_list[id][4])

func _on_copy_wallet_address_pressed():
	DisplayServer.clipboard_set($wallet_address.text)

func _on_copy_price_pressed():
	DisplayServer.clipboard_set($price.text)

func _on_copy_all_pressed():
	DisplayServer.clipboard_set(pay_list[$paymentList.selected][0] + "\n" + $wallet_address.text + "\n" + $price.text + "\n" + $txid.text)

func remove_all_whitespace(temp):
	var regex = RegEx.new()
	regex.compile("\\S+") # Negated whitespace character class.
	var final_str = ""
	for result in regex.search_all(temp):
		final_str += result.get_string()
	return final_str

func _on_paste_txid_pressed():
	# we have to remove all white space from clipboard
	$txid.text = remove_all_whitespace(DisplayServer.clipboard_get())
	_on_txid_text_changed($txid.text)

func _on_txid_text_changed(_new_text):
	if verify_clicked and $txid.text.length() > 0:
		$HBoxContainer/Verify.disabled = false
		$HBoxContainer/Verify.self_modulate = enable_color
	elif $txid.text.length() > 0 and $price.text != "":
		$HBoxContainer/Verify.disabled = false
		$HBoxContainer/Verify.self_modulate = enable_color
	else:
		$HBoxContainer/Verify.disabled = true
		$HBoxContainer/Verify.self_modulate = disable_color

func check_time(text_time):
	var parts = text_time.split(":", true)
	if parts.size() != 3:
		return false
	return true

# here we compare times to be sure time2 is between t1 and t1 + 10min
func compare_times(t1, t2):
	var parts = t1.split(":", true)
	if parts.size() != 3:
		return false
	var hr1 = int(parts[0])
	var mi1 = int(parts[1])
	var se1 = int(parts[2])
	parts = t2.split(":", true)
	if parts.size() != 3:
		return false
	var hr2 = int(parts[0])
	var mi2 = int(parts[1])
	var se2 = int(parts[2])
	if (hr1 == hr2) and (mi1 == mi2) and (se1 == se2):
		return true
	var op_time = int(time_of_payment / 60)
	mi1 += op_time
	if mi1 >= 60:
		mi1 = mi1 % 60
		hr1 += 1
		if hr1 >= 24:
			hr1 = hr1 % 24
	if (hr1 == hr2) and (mi1 - mi2) >= 0 and (mi1 - mi2) <= op_time:
		return true
	if (hr1 < hr2):
		mi1 += op_time
		if mi1 >= 60:
			mi1 = mi1 % 60
		if (mi2 <= mi1) and (abs(mi1 - mi2) < op_time):
			return true
	if (hr2 < hr1) and ((hr1 - hr2) == 23):
		day_changed = true
		if mi1 >= mi2:
			mi1 += op_time
			if mi1 >= 60:
				mi1 = mi1 % 60
			if mi1 >= mi2:
				return true
	return false

func _on_HTTPRequest2_request_completed(_result, _response_code, _headers, _body):
	final_body_content = _body
	if txid_error:
		return
	if _result != 0 or final_body_content.size() < time_of_payment:
		$netDialog.show()
		return
	else:
		web_content = final_body_content.get_string_from_utf8()
		date_tomorrow = change_date_format(date_tomorrow)
		var time2_array = web_content.find("UTC</p></div><div")
		if time2_array == -1:
			$txidDialog.show()
			return
		time2_payment_registered = web_content.substr(time2_array - 8, 8)
		verify_payment()

func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")
	self.queue_free()

func _on_help_pressed():
	$Help_section.show()

func _on_currency_logo_pressed():
	OS.shell_open("https://duckduckgo.com/?q=cryptocurrency " + str($paymentList.text))

func _on_txidDialog_confirmed():
	txid_error = false
	$HBoxContainer/Verify.disabled = false
	$HBoxContainer/Verify.self_modulate = enable_color
	$Timer.start()
	return

func _on_txidDialog_visibility_changed():
	txid_error = true
	$HBoxContainer/Verify.disabled = true
	$HBoxContainer/Verify.self_modulate = disable_color

func _on_priceDialog_confirmed():
	$paymentList.disabled = false

func _on_priceDialog_visibility_changed():
	price_error = true

func _on_Exit_help_pressed():
	$Help_section.hide()

func _on_netDialog_confirmed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")
	return

func _on_paste_txid_mouse_entered():
	$paste_txid.self_modulate = "929fe8"

func _on_paste_txid_mouse_exited():
	$paste_txid.self_modulate = "ffffff"

func _on_paste_txid_button_down():
	$paste_txid.self_modulate = "6071cf"	

func _on_paste_txid_button_up():
	$paste_txid.self_modulate = "929fe8"

func _on_copy_wallet_address_mouse_entered():
	$copy_wallet_address.self_modulate = "aad8f7"

func _on_copy_wallet_address_mouse_exited():
	$copy_wallet_address.self_modulate = "ffffff"

func _on_copy_wallet_address_button_down():
	$copy_wallet_address.self_modulate = "6071cf"

func _on_copy_wallet_address_button_up():
	$copy_wallet_address.self_modulate = "aad8f7"

func _on_copy_price_mouse_entered():
	$copy_price.self_modulate = "aad8f7"

func _on_copy_price_mouse_exited():
	$copy_price.self_modulate = "ffffff"

func _on_copy_price_button_down():
	$copy_price.self_modulate = "6071cf"

func _on_copy_price_button_up():
	$copy_price.self_modulate = "aad8f7"

func _on_copy_all_mouse_entered():
	$HBoxContainer/copy_all.self_modulate = "aad8f7"

func _on_copy_all_mouse_exited():
	$HBoxContainer/copy_all.self_modulate = "ffffff"

func _on_copy_all_button_down():
	$HBoxContainer/copy_all.self_modulate = "6071cf"

func _on_copy_all_button_up():
	$HBoxContainer/copy_all.self_modulate = "aad8f7"

func _on_Back_mouse_entered():
	$HBoxContainer/Back.self_modulate = "aad8f7"

func _on_Back_mouse_exited():
	$HBoxContainer/Back.self_modulate = "ffffff"

func _on_Back_button_down():
	$HBoxContainer/Back.self_modulate = "6071cf"

func _on_help_mouse_entered():
	$HBoxContainer/help.self_modulate = "6ec983"

func _on_help_mouse_exited():
	$HBoxContainer/help.self_modulate = "ffffff"

func _on_help_button_down():
	$HBoxContainer/help.self_modulate = "3e7b4c"

func _on_Verify_mouse_entered():
	if not $HBoxContainer/Verify.disabled:
		$HBoxContainer/Verify.self_modulate = "fb2da6"

func _on_Verify_mouse_exited():
	if not $HBoxContainer/Verify.disabled:
		$HBoxContainer/Verify.self_modulate = "c40bff"

func _on_Verify_button_down():
	if not $HBoxContainer/Verify.disabled:
		$HBoxContainer/Verify.self_modulate = "0b70ff"

func _on_Verify_button_up():
	if not $HBoxContainer/Verify.disabled:
		$HBoxContainer/Verify.self_modulate = "fb2da6"

func _on_Exit_help_mouse_entered():
	$Help_section/Exit_help.self_modulate = "aad8f7"

func _on_Exit_help_mouse_exited():
	$Help_section/Exit_help.self_modulate = "ffffff"

func _on_Exit_help_button_down():
	$Help_section/Exit_help.self_modulate = "6071cf"

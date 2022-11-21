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
const APP_PRICE_A_DAY_IN_DOLLAR = 0.10
const PAYMENTLIST_INIT_SELECTED = 3
const MINIMUM_LIMIT_PRICE = 0.00000001
const disable_color = "803f3f3f"
const enable_color = "c40bff"
const INIT_TIME_TEXT = "10 : 00"
const FINISHED_TIME_TEXT = "00 : 00"
const RED_COLOR = "ff0000"
const GREEN_COLOR = "00ff00"
const BLUE_COLOR = "0000ff"

const MAX_TIME_OF_PAYMENT = 600
var time_of_payment = MAX_TIME_OF_PAYMENT

var web_content := ""
var web_content_price := ""
var txid := ""
var time1_price_checked := ""
var time2_payment_registered := ""
var day_changed := false
var init_time_register := ""
var final_time_register := ""
var my_wallet_address_to_receive_money := ""
var value_of_money := ""
var date_today := ""
var date_tomorrow := ""

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
	["Bitcoin (BTC)", "https://www.livecoinwatch.com/price/Bitcoin-BTC", "1LQSzFZKE5vwiUS94toMG7r5M2nQ4X2muw", "https://bitcoinblockexplorers.com/tx/", "res://Payment/Photos/Bitcoin (BTC).png"],
	["Bitcoin Cash (BCH)", "https://www.livecoinwatch.com/price/BitcoinCash-BCH", "bitcoincash:qzhr6lc9r64c3wg3jnndqaxzpyxeghdp2s57w5wgwu", "https://bchblockexplorer.com/tx/", "res://Payment/Photos/Bitcoin Cash (BCH).png"],
	["Bitcoin Gold (BTG)", "https://www.livecoinwatch.com/price/BitcoinGold-BTG", "GJbYu4YviyCi8azMV6ZAvdhjJTcigdmnPV", "https://btgexplorer.com/tx/", "res://Payment/Photos/Bitcoin Gold (BTG).png"],
	["Dash (DASH)", "https://www.livecoinwatch.com/price/Dash-DASH", "Xn5HwktiWJfgKydTDjodBTjJDA6tVxzAho", "https://dashblockexplorer.com/tx/", "res://Payment/Photos/Dash (DASH).png"],
	["DigiByte (DGB)", "https://www.livecoinwatch.com/price/DigiByte-DGB", "D97CQ5pV1AukRY1FJTSW3CFkJtUZgdwJq4", "https://digibyteblockexplorer.com/tx/", "res://Payment/Photos/DigiByte (DGB).png"],
	["Dogecoin (DOGE)", "https://www.livecoinwatch.com/price/Dogecoin-DOGE", "D5YP7CggUUkS3fu1B7RjhjJ7jvNu6A4Ksx", "https://dogeblocks.com/tx/", "res://Payment/Photos/Dogecoin (DOGE).png"],
	["Ethereum (ETH)", "https://www.livecoinwatch.com/price/Ethereum-ETH", "0x80D3CA7528cF05118131dBa3d7852Db2685c4b9E", "https://ethblockexplorer.org/tx/", "res://Payment/Photos/Ethereum (ETH).png"],
	["FIRO (FIRO)", "https://www.livecoinwatch.com/price/FIRO-FIRO", "a5R3Z4XBjj9oQS6kMgtfT5kMYMnA8Qx2Ga", "https://firoblockexplorers.com/tx/", "res://Payment/Photos/FIRO (FIRO).png"],
	["Komodo (KMD)", "https://www.livecoinwatch.com/price/Komodo-KMD", "RQzp2jDRhRMrzBJZobGtUQhkQfcnfXdxWz", "https://komodoblockexplorer.com/tx/", "res://Payment/Photos/Komodo (KMD).png"],
	["Litecoin (LTC)", "https://www.livecoinwatch.com/price/Litecoin-LTC", "LRQ6TBVXsEVPApbCY79bV1d9LR8E7JiuDd", "https://litecoinblockexplorer.net/tx/", "res://Payment/Photos/Litecoin (LTC).png"],
	["Qtum (QTUM)", "https://www.livecoinwatch.com/price/Qtum-QTUM", "QXFD7QitfegWXf4n4F9bVLU9HXqESgRVWq", "https://qtumblockexplorer.com/tx/", "res://Payment/Photos/Qtum (QTUM).png"],
	["Ravencoin (RVN)", "https://www.livecoinwatch.com/price/Ravencoin-RVN", "RLMJbB268ayzGtJokjimNiLgdAccF8yv21", "https://rvnblockexplorer.com/tx/", "res://Payment/Photos/Ravencoin (RVN).png"],
	["ReddCoin (RDD)", "https://www.livecoinwatch.com/price/ReddCoin-RDD", "RvawiN6Ues4gxdu52JkKLQ7cKYSDDYwkUQ", "https://rddblockexplorer.com/tx/", "res://Payment/Photos/ReddCoin (RDD).png"],
	["Verge (XVG)", "https://www.livecoinwatch.com/price/Verge-XVG", "DKY9rZfiw6qShLvWzKZCmuKJdiadDyhnVr", "https://xvgblockexplorer.com/tx/", "res://Payment/Photos/Verge (XVG).png"],
	["Vertcoin (VTC)", "https://www.livecoinwatch.com/price/Vertcoin-VTC", "VmLS1YQuRVJT73ZkQyQNKWUPUCEsC95MSJ", "https://vtcblocks.com/tx/", "res://Payment/Photos/Vertcoin (VTC).png"],
	["Zcash (ZEC)", "https://www.livecoinwatch.com/price/Zcash-ZEC", "t1gFJup6Mri4mZ1Pgqgzqmz2a3hg66Cpyga", "https://zecblockexplorer.com/tx/", "res://Payment/Photos/Zcash (ZEC).png"],
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
	var _s = http_request.connect("request_completed", self, "_on_HTTPRequest_request_completed")
	first_http_call()

func first_http_call():
	var error = http_request.request(pay_list[$paymentList.selected][1])
	if error != OK:
		$netDialog.show()
		return
	$paymentList.disabled = true
	$Verify.disabled = true
	$Verify.self_modulate = disable_color

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
		$Verify.disabled = true
		$Verify.self_modulate = disable_color
		$Timer.stop()
		time_of_payment = 0
		var _s = get_tree().change_scene("res://Main/Main.tscn")

func _on_Verify_pressed():
	$paymentList.disabled = true
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
	$Verify.disabled = true
	$Verify.self_modulate = disable_color

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
		var today = content.split("priceValidUntil", true)
		if today.size() < 2:
			$netDialog.show()
			return
		today = today[1].split("offerCount", true)[0]
		var today_array = today.split("\"", true)
		if today_array.size() < 3:
			$netDialog.show()
			return
		today = today_array[2]
		var date_tomorrow_array = today.split("T", true)
		if date_tomorrow_array.size() < 2:
			$netDialog.show()
			return
		date_tomorrow = date_tomorrow_array[0]
		var time_array = today.split("T", true)
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

		var splitted = content.split("}}]}", true, 2)
		if splitted.size() < 2:
			$netDialog.show()
			return
		var sen1 = splitted[1]
		var sen2 = sen1.split("\"priceCurrency\":\"USD\",", true)
		if sen2.size() < 2 or not("," in sen2[1]) or not("\"" in sen2[1]) or not(":" in sen2[1]):
			$netDialog.show()
			return
		var the_new_sen = sen2[1].replace(",", "")
		the_new_sen = the_new_sen.replace("\"", "")
		var array_sen = the_new_sen.split(":", true)
		if array_sen.size() < 5:
			$netDialog.show()
			return
		var crypto_in_dollar = float(array_sen[1])
		var date_valid_price_array = array_sen[4].split("T", true)
		if date_valid_price_array.size() < 2:
			$netDialog.show()
			return
		var date_valid_price = date_valid_price_array[0]
	#	var crypto_high_price_in_dollar = float(array_sen[2])
	#	var crypto_low_price_in_dollar = float(array_sen[3])
		var user_price = APP_PRICE_A_DAY_IN_DOLLAR / crypto_in_dollar
		if user_price < MINIMUM_LIMIT_PRICE:
			$priceDialog.show()
			return
		else:
			user_price = "%.8f" % user_price
			$price.text = user_price
			value_of_money = user_price
			date_tomorrow = date_valid_price
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
	print("time1_price_checked: " + time1_price_checked)
	print("time2_payment_registered: " + time2_payment_registered)
	date_today = change_date_format(date_today)
	date_tomorrow = change_date_format(date_tomorrow)
	print("today: " + date_today)
	print("tomorrow: " + date_tomorrow)
	var bought_it = false
	if txid in web_content:
		if my_wallet_address_to_receive_money in web_content:
			print("AAA")
			if value_of_money in web_content:
				print("BBB")
				if (date_today in web_content) or (date_tomorrow in web_content):
					print("CCC")
					if check_time(time2_payment_registered) and compare_times(time1_price_checked, time2_payment_registered):
						print("DDD")
						if day_changed:
							if (date_tomorrow in web_content):
								print("EEE")
								bought_it = true
						else:
							if (date_today in web_content):
								print("FFF")
								bought_it = true
	if bought_it:
		# if you buy it successfully
		var _s = get_tree().change_scene("res://Payment/You_Bought_this.tscn")
		return
	else:
		$txidDialog.show()

func _on_paymentList_item_selected(id):
	if verify_clicked:
		$paymentList.disabled = true
		return
	price_error = false
	$Timer.stop()
	reset_time()
	$paymentList.disabled = true
	$Verify.disabled = true
	$Verify.self_modulate = disable_color
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
	OS.set_clipboard($wallet_address.text)

func _on_copy_price_pressed():
	OS.set_clipboard($price.text)

func _on_copy_all_pressed():
	OS.set_clipboard(pay_list[$paymentList.selected][0] + "\n" + $wallet_address.text + "\n" + $price.text + "\n" + $txid.text)

func remove_all_whitespace(temp):
	var regex = RegEx.new()
	regex.compile("\\S+") # Negated whitespace character class.
	var final_str = ""
	for result in regex.search_all(temp):
		final_str += result.get_string()
	return final_str

func _on_paste_txid_pressed():
	# we have to remove all white space from clipboard
	$txid.text = remove_all_whitespace(OS.get_clipboard())
	_on_txid_text_changed($txid.text)

func _on_txid_text_changed(_new_text):
	if verify_clicked and $txid.text.length() > 0:
		$Verify.disabled = false
		$Verify.self_modulate = enable_color
	elif $txid.text.length() > 0 and $price.text != "":
		$Verify.disabled = false
		$Verify.self_modulate = enable_color
	else:
		$Verify.disabled = true
		$Verify.self_modulate = disable_color

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
	var _s = get_tree().change_scene("res://Main/Main.tscn")
	self.queue_free()

func _on_help_pressed():
	$Help_section.show()

func _on_currency_logo_pressed():
	var _s = OS.shell_open("https://duckduckgo.com/?q=cryptocurrency " + str($paymentList.text))

func _on_txidDialog_confirmed():
	txid_error = false
	$Verify.disabled = false
	$Verify.self_modulate = enable_color
	$Timer.start()
	return

func _on_txidDialog_visibility_changed():
	txid_error = true
	$Verify.disabled = true
	$Verify.self_modulate = disable_color

func _on_priceDialog_confirmed():
	$paymentList.disabled = false

func _on_priceDialog_visibility_changed():
	price_error = true

func _on_Exit_help_pressed():
	$Help_section.hide()

func _on_netDialog_confirmed():
	var _s = get_tree().change_scene("res://Main/Main.tscn")
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
	$copy_all.self_modulate = "aad8f7"

func _on_copy_all_mouse_exited():
	$copy_all.self_modulate = "ffffff"

func _on_copy_all_button_down():
	$copy_all.self_modulate = "6071cf"

func _on_copy_all_button_up():
	$copy_all.self_modulate = "aad8f7"

func _on_Back_mouse_entered():
	$Back.self_modulate = "aad8f7"

func _on_Back_mouse_exited():
	$Back.self_modulate = "ffffff"

func _on_Back_button_down():
	$Back.self_modulate = "6071cf"

func _on_help_mouse_entered():
	$help.self_modulate = "6ec983"

func _on_help_mouse_exited():
	$help.self_modulate = "ffffff"

func _on_help_button_down():
	$help.self_modulate = "3e7b4c"

func _on_Verify_mouse_entered():
	if not $Verify.disabled:
		$Verify.self_modulate = "fb2da6"

func _on_Verify_mouse_exited():
	if not $Verify.disabled:
		$Verify.self_modulate = "c40bff"

func _on_Verify_button_down():
	if not $Verify.disabled:
		$Verify.self_modulate = "0b70ff"

func _on_Verify_button_up():
	if not $Verify.disabled:
		$Verify.self_modulate = "fb2da6"

func _on_Exit_help_mouse_entered():
	$Help_section/Exit_help.self_modulate = "aad8f7"

func _on_Exit_help_mouse_exited():
	$Help_section/Exit_help.self_modulate = "ffffff"

func _on_Exit_help_button_down():
	$Help_section/Exit_help.self_modulate = "6071cf"

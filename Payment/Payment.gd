extends Control

# This is very important to check if the current payment method working or not
# Especially for users who want to pay, and don't want to lose money without buying!
const PAYMENT_VERSION : String = "(1.1)"
const VERSION_PAGE = "https://raw.githubusercontent.com/bdshahab/in-app-purchasing-by-crypto/main/README.md"
#User only have limited time(for example: 10 min)
#to register payment. Otherwise, it will be close.
#
#1. User picks the method pay
#2. app show the price in that currency and register date of today and tomorrow
#3. User have to send exact that amount of money to the bdshahab address.
#4. User have to register payment TXID in limited time.
#5. app verify the payment with registered price in that time
#price check by https://coinmarketcap.com

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
var http_request: HTTPRequest
var http_request_for_date: HTTPRequest
var txid_error := false
var price_error := false
var final_body_content
var final_body_content_price
var verify_clicked = false
const monthsh=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
# 14 currency methods
# name of currency / price check site / wallet address / verify site / Icon
# all of the verify site are same as each other which guarda uses.
const pay_list = [
	["Bitcoin (BTC)", "https://coinmarketcap.com/currencies/bitcoin", "1LQSzFZKE5vwiUS94toMG7r5M2nQ4X2muw", "https://bitcoinblockexplorers.com/tx/", "res://Payment/Photos/bitcoin (btc).png"],
	["Bitcoin Cash (BCH)", "https://coinmarketcap.com/currencies/bitcoin-cash", "bitcoincash:qzhr6lc9r64c3wg3jnndqaxzpyxeghdp2s57w5wgwu", "https://bchblockexplorer.com/tx/", "res://Payment/Photos/bitcoin cash (bch).png"],
	["Bitcoin Gold (BTG)", "https://coinmarketcap.com/currencies/bitcoin-gold", "GJbYu4YviyCi8azMV6ZAvdhjJTcigdmnPV", "https://btgexplorer.com/tx/", "res://Payment/Photos/bitcoin gold (btg).png"],
	["Dash (DASH)", "https://coinmarketcap.com/currencies/dash", "Xn5HwktiWJfgKydTDjodBTjJDA6tVxzAho", "https://dashblockexplorer.com/tx/", "res://Payment/Photos/dash (dash).png"],
	["DigiByte (DGB)", "https://coinmarketcap.com/currencies/digibyte", "D97CQ5pV1AukRY1FJTSW3CFkJtUZgdwJq4", "https://digibyteblockexplorer.com/tx/", "res://Payment/Photos/digibyte (dgb).png"],
	["Dogecoin (DOGE)", "https://coinmarketcap.com/currencies/dogecoin", "D5YP7CggUUkS3fu1B7RjhjJ7jvNu6A4Ksx", "https://dogeblocks.com/tx/", "res://Payment/Photos/dogecoin (doge).png"],
	["Ethereum (ETH)", "https://coinmarketcap.com/currencies/ethereum", "0x80D3CA7528cF05118131dBa3d7852Db2685c4b9E", "https://ethblockexplorer.org/tx/", "res://Payment/Photos/ethereum (eth).png"],
	["FIRO (FIRO)", "https://coinmarketcap.com/currencies/firo", "a5R3Z4XBjj9oQS6kMgtfT5kMYMnA8Qx2Ga", "https://firoblockexplorers.com/tx/", "res://Payment/Photos/firo (firo).png"],
	["Komodo (KMD)", "https://coinmarketcap.com/currencies/komodo", "RQzp2jDRhRMrzBJZobGtUQhkQfcnfXdxWz", "https://komodoblockexplorer.com/tx/", "res://Payment/Photos/komodo (kmd).png"],
	["Litecoin (LTC)", "https://coinmarketcap.com/currencies/litecoin", "LRQ6TBVXsEVPApbCY79bV1d9LR8E7JiuDd", "https://litecoinblockexplorer.net/tx/", "res://Payment/Photos/litecoin (ltc).png"],
	["Qtum (QTUM)", "https://coinmarketcap.com/currencies/qtum", "QXFD7QitfegWXf4n4F9bVLU9HXqESgRVWq", "https://qtumblockexplorer.com/tx/", "res://Payment/Photos/qtum (qtum).png"],
	["Ravencoin (RVN)", "https://coinmarketcap.com/currencies/ravencoin", "RLMJbB268ayzGtJokjimNiLgdAccF8yv21", "https://rvnblockexplorer.com/tx/", "res://Payment/Photos/ravencoin (rvn).png"],
	["ReddCoin (RDD)", "https://coinmarketcap.com/currencies/redd", "RvawiN6Ues4gxdu52JkKLQ7cKYSDDYwkUQ", "https://rddblockexplorer.com/tx/", "res://Payment/Photos/reddcoin (rdd).png"],
	["Verge (XVG)", "https://coinmarketcap.com/currencies/verge", "DKY9rZfiw6qShLvWzKZCmuKJdiadDyhnVr", "https://xvgblockexplorer.com/tx/", "res://Payment/Photos/verge (xvg).png"],
	["Vertcoin (VTC)", "https://coinmarketcap.com/currencies/vertcoin", "VmLS1YQuRVJT73ZkQyQNKWUPUCEsC95MSJ", "https://vtcblocks.com/tx/", "res://Payment/Photos/vertcoin (vtc).png"],
	["Zcash (ZEC)", "https://coinmarketcap.com/currencies/zcash", "t1gFJup6Mri4mZ1Pgqgzqmz2a3hg66Cpyga", "https://zecblockexplorer.com/tx/", "res://Payment/Photos/zcash (zec).png"],
]
@onready var txidDialog = $txidDialog
@onready var date_dialog = $dateDialog
@onready var wallet_dialog = $walletDialog
@onready var money_dialog = $moneyDialog
@onready var time_dialog = $timeDialog
@onready var net_dialog = $netDialog
@onready var price_dialog = $priceDialog
@onready var payment_version_dialog = $payment_version_Dialog
@onready var used_txid_dialog = $used_txidDialog

var used_txid = []

func check_payment_update():
	var http_request_check_payment_update = HTTPRequest.new()
	add_child(http_request_check_payment_update)
	http_request_check_payment_update.request_completed.connect(self._on_request_check_payment_update_completed)
	var error = http_request_check_payment_update.request(VERSION_PAGE)
	if error != OK:
		net_dialog.show()
		return

func _on_request_check_payment_update_completed(result, _response_code, _headers, body):
	if result == OK:
		var script_code_version : String = body.get_string_from_utf8()
		var the_content = (script_code_version.split("\n"))
		var the_part = the_content[0].split(" ")
		the_part = the_part[the_part.size() - 1]
		the_part = the_part.strip_edges(true, true)
		if the_part != PAYMENT_VERSION:
			payment_version_dialog.show()
			return
		else:
			real_ready()
	else:
		net_dialog.show()
		return

func _on_payment_version_dialog_confirmed():
	get_tree().change_scene_to_file("res://About/about.tscn")

func _ready():
	for i in range(pay_list.size()):
		$paymentList.add_item(pay_list[i][0])
	$paymentList.selected = PAYMENTLIST_INIT_SELECTED
	set_currency_logo(PAYMENTLIST_INIT_SELECTED)
	$txid.text = ""
	$wallet_address.text = pay_list[$paymentList.selected][2]
	$currency_logo.texture_normal = load(pay_list[$paymentList.selected][4])
	check_payment_update()

func real_ready():
	reset_time()
	http_request = HTTPRequest.new()
	http_request_for_date = HTTPRequest.new()
	add_child(http_request)
	add_child(http_request_for_date)
	txid_error = false
	price_error = false
	http_request.connect("request_completed",Callable(self,"_on_HTTPRequest_request_completed"))
	http_request_for_date.connect("request_completed",Callable(self,"_on_HTTPRequest_for_date_request_completed"))
	first_http_call()
	$currency_logo.tooltip_text = $paymentList.text

func first_http_call():
	var error = http_request.request(pay_list[$paymentList.selected][1])
	if error != OK:
		net_dialog.show()
		return
	$paymentList.disabled = true
	$HBoxContainer/Verify.disabled = true
	$HBoxContainer/Verify.self_modulate = disable_color
	get_date_http_call()

func get_date_http_call():
	if http_request_for_date.is_processing():
		return
	var error = http_request_for_date.request("https://time.is/UTC")
	if error != OK:
		net_dialog.show()
		return

func reset_time():
	$Label_time.text = INIT_TIME_TEXT
	time_of_payment = MAX_TIME_OF_PAYMENT
	$Label_time.self_modulate = GREEN_COLOR
	if http_request_for_date != null:
		http_request_for_date.cancel_request()
		get_date_http_call()

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
	date = date.replace(",", "")
	var splitted = date.split(" ")
	if splitted.size() != 3:
		return date
	var year = splitted[2]
	var month = splitted[0]
	var day = splitted[1]
	for i in range(monthsh.size()):
		if month.substr(0, 3) == monthsh[i]:
			month = monthsh[i]
			break
	# May 19 2023
	return day + " " + month + " " + year

func change_date_format_from_standard(date: String):
	var splitted = date.split("-")
	if splitted.size() != 3:
		return date
	var year = splitted[0]
	var month = splitted[1]
	var day = splitted[2]
	for i in range(monthsh.size()):
		if int(month) == i + 1:
			month = monthsh[i]
			break
	# 19 May 2023
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
	$txid.text = remove_all_whitespace($txid.text)
	$paymentList.disabled = true
	$paymentList.self_modulate = "#1FFF72"
	if not $HTTPRequest2.is_processing():
		$HTTPRequest2.cancel_request()
		var error = $HTTPRequest2.request(pay_list[$paymentList.selected][3] + $txid.text)
		if error != OK:
			net_dialog.show()
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
			net_dialog.show()
			return
		verify_clicked = true
	$HBoxContainer/Verify.disabled = true
	$HBoxContainer/Verify.self_modulate = disable_color

func _on_HTTPRequest_request_completed(_result, _response_code, _headers, _body):
	# for manually exception handling!
	final_body_content_price = _body
	if txid_error:
		return
	if _result != 0 or final_body_content_price == null or _body.size() < time_of_payment:
		net_dialog.show()
		return
	else:
		checking_price()

func _on_HTTPRequest_for_date_request_completed(_result, _response_code, _headers, _body):
	# for manually exception handling!
	if txid_error:
		return
	if _result != 0 or _body == null or _body.size() < time_of_payment:
		net_dialog.show()
		return
	else:
		# here get date
		var regex = RegEx.new()
		regex.compile("(\\w+) (\\d{1,2}), (\\d{4})")
		var result = regex.search(_body.get_string_from_utf8()) # search the string for the pattern
		if result: # if a match is found
			date_today = change_date_format(result.get_string(0))
		regex = RegEx.new()
		regex.compile("(\\d{2}):(\\d{2}):(\\d{2})")
		var result2 = regex.search(_body.get_string_from_utf8()) # search the string for the pattern
		if result2: # if a match is found
			time1_price_checked = result2.get_string(0)

func get_price_of_this_currency(text: String):
	var the_array = text.split("with a 24-hour trading volume")
	text = the_array[0]
	text = text.right(80)
	var regex = RegEx.new() # create a new RegEx object
	regex.compile("price.*\\$?(\\d{1,3}(,\\d{3})*(\\.\\d+)?)( USD)?") # compile a pattern that matches the "price" word, followed by any number of any characters, followed by an optional dollar sign, followed by a capture group that matches one to three digits, followed by zero or more groups of a comma and three digits, followed by an optional dot and one or more digits, followed by an optional space and "USD"
	var result = regex.search(text) # search the string for the pattern
	if result: # if a match is found
		var output = result.get_string(0).split(" USD")[0]
		output = output.split("$")[1] #get price afte dollar sign
		output = output.replace(",", "") # replace the comma with an empty string
		return output
	else: # if no match is found
		return null

func checking_price():
	if price_error or final_body_content_price == null:
		return
	var content = final_body_content_price.get_string_from_utf8()
	var crypto_in_dollar = float(get_price_of_this_currency(content))
	var array = content.find("price")
	if not txid_error and (content == null or content.length() < MAX_TIME_OF_PAYMENT):
		net_dialog.show()
		return
	elif array == -1:
		net_dialog.show()
		return
	elif not verify_clicked:
		init_time_register = ""
		final_time_register = ""
		init_time_register = time1_price_checked
		var user_price = APP_PRICE_A_DAY_IN_DOLLAR / crypto_in_dollar
		if user_price < MINIMUM_LIMIT_PRICE:
			price_dialog.show()
			return
		else:
			user_price = "%.8f" % user_price
			$price.text = user_price
			value_of_money = user_price
			my_wallet_address_to_receive_money = pay_list[$paymentList.selected][2]
			txid = $txid.text
		_on_txid_text_changed(txid)
		$paymentList.disabled = false
		reset_time()
		$Timer.start()

func get_tomorrow_by_date(date_month_day_year: String):
	var the_splitted = date_month_day_year.split(" ")
	for i in range(monthsh.size()):
		if the_splitted[1] == monthsh[i]:
			the_splitted[1] = "%02d" % (i + 1)
			break
	var unix_time = Time.get_unix_time_from_system()
	var tomorrow = (Time.get_date_dict_from_unix_time(unix_time + 24 * 60 * 60))
	return str(tomorrow["year"]) + "-" + str(tomorrow["month"]) + "-" + str(tomorrow["day"])

func get_fee():
	var the_index = 'Transaction Fee</p><p class="title is-6">'
	var the_end_index = " "
	var the_text = web_content.split(the_index)[1]
	return float(the_text.split(the_end_index)[0])

func get_real_money_comes_to_account():
	var the_index = '"vout":[{"value":'
	var the_end_index = ',"n":0,"scriptPubKey"'
	
	var the_text = web_content.split(the_index)[1]
	return float(the_text.split(the_end_index)[0])

func calculate_remaining_price():
	value_of_money = str(float($price.text) - (get_real_money_comes_to_account() + get_fee()))
	$price.text = value_of_money

# This method checks the receipt of the payment site like this:
# https://litecoinblockexplorer.net/tx/61a7667851da2d1395c26f4eaba7a14a3c1355ba80e1b35678327619a115d21e
func verify_payment():
	if txid_error:
		return
	txid = $txid.text
	
	var date_tomorrow = get_tomorrow_by_date(date_today)
	date_tomorrow = change_date_format_from_standard(date_tomorrow)
	var bought_it = false
	var date_passed = true
	var wallet_passed = false
	var time_passed = true
	# we have to look at address if and only if it comes after /address/ phrase.
	my_wallet_address_to_receive_money = "/address/" + my_wallet_address_to_receive_money
	if txid in web_content:#web_content_price
		if my_wallet_address_to_receive_money in web_content:
			wallet_passed = true
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
		if txid in used_txid:
			used_txid_dialog.show()
			return
		used_txid.append(txid)
		calculate_remaining_price()
		if float(value_of_money) <= 0:
			# if you buy it successfully
			get_tree().change_scene_to_file("res://Payment/You_Bought_this.tscn")
		else:
			bought_it = false
			money_dialog.show()
	else:
		if not wallet_passed:
			wallet_dialog.show()
		elif not time_passed:
			time_dialog.show()
		elif not date_passed:
			date_dialog.show()
		else:
			txidDialog.show()

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
		net_dialog.show()
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
	# Removing the unnecessary part. We only want the TXID part and not the receipt link.
	if "/" in _new_text:
		var the_content = (_new_text.split("/"))
		$txid.text = the_content[the_content.size() - 1]
	if $HTTPRequest2.is_processing():
		return
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
	if _result != 0 or final_body_content == null or final_body_content.size() < time_of_payment:
		net_dialog.show()
		return
	else:
		web_content = final_body_content.get_string_from_utf8()
		var time2_array = web_content.find("UTC</p></div><div")
		if time2_array == -1:
			txidDialog.show()
			return
		var regex = RegEx.new()
		regex.compile("(\\d{2}):(\\d{2}):(\\d{2})")
		var result2 = regex.search(web_content)
		if result2: # if a match is found
			time2_payment_registered = result2.get_string(0)
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

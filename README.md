# In-app purchasing by cryptocurrency

(It's not a plugin!)

Published in Python and 2 Game Engines:

Defold: https://defold.com/assets/crypto_iap

Godot: https://godotengine.org/asset-library/asset/3158

Python (PySide6): https://github.com/bdshahab/iap_qt

Python (tkinter): https://github.com/bdshahab/iap_tkinter

<img width="859" alt="1" src="https://raw.githubusercontent.com/bdshahab/in-app-purchasing-by-crypto/refs/heads/main/pyside6_1.png">


A simple way to enable in-app purchases using cryptocurrencies.

<img width="866" alt="2" src="https://raw.githubusercontent.com/bdshahab/in-app-purchasing-by-crypto/refs/heads/main/pyside6_2.png">


A video clip about this method:

https://www.youtube.com/watch?v=z6vrjm8vtMI


Using this program's method, you can make in-app purchases using cryptocurrencies.


Users only had a limited time to finish the payment.

The user picks the payment method, and then the app shows the price in that currency. The user has to send that amount of money to the address. The user has to paste the [TXID] of the payment in the program. The app will verify the payment with the registered price at that time.

# Full description of this method

In-app payment using cryptocurrencies

Due to various restrictive laws or sanctions, financial exchanges are not available freely and equally for everyone worldwide. Still, cryptocurrencies do not have any geographical limitations, and they are not limited to anyone. App stores usually follow those rules and sanctions, so some developers cannot sell their products.

However, those app stores also deduct a significant percentage of the sales as commissions and taxes from the income of developers! However, making in-app purchases using cryptocurrencies is possible to prevent that.

In fact, with this method, the need for banks and app stores is eliminated, and as a result, no one will be under legal restrictions or sanctions, and the entire income will directly go to the developers, and they will not need to pay fees and taxes.

How the program works: The programmer puts the price of the program based on dollars in his program, and then the program shows the user the price of the program according to the price of the selected digital currency every time it is executed.

It is possible to determine the price by using one of the cryptocurrency price announcement sites by raw source code. Then, the user must deposit the desired price in that cryptocurrency to the specified account address within the time limit. Each money deposit through cryptocurrencies has a payment ID(Transaction Hash ID); The user must provide that payment ID to the app to validate it; if it is validated, the purchase will be accepted.

Various cryptocurrency transaction tracking sites can be used to confirm the payment.

Cryptocurrencies are free for everyone to use. Websites announcing the price of cryptocurrencies are also free for everyone to access. Websites tracking transactions are also freely accessible. As a result, programmers don't need middlemen to pay them for these financial affairs and sell their products. There is no law or sanction against this method of earning money; only accessing the Internet is enough.

For those cases where the price announcement site is down, a default price list has been placed on this GitHub site to be used. These default prices are in their folder (default prices) on this site.

Key information is updated through a special file (key_data.txt) on this GitHub site so that possible problems can be solved quickly in the future, and there is no need to produce a new program and download it to the customer.

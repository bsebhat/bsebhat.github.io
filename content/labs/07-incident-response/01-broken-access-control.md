---
title: 01 Broken Access Control
type: docs
---

I'm going to use this `hacker` VM to exploit some of the [built-in vulnerabilities](https://pwning.owasp-juice.shop/companion-guide/latest/appendix/solutions.html) of the Juice Shop web application. The vulnerabilities are considered "challenges" that test the skills of penetration testers. Some challenges are considered easier, and have a "one star" score. The more difficult the exploit, the more stars.

They are also organized into [vulnerability categories](https://owasp.org/www-project-juice-shop/#div-challenges), like "Broken Authentication" and "Improper Input Validation".

For some of the exploits, I'll be using a penetration testing tool called [Burp Suite](https://portswigger.net/burp/) community edition. It's included on the `hacker` VM because it's running Kali Linux, but you can install it on Windows or Linux distros.

## Exploiting A Common Web Vulnerability
I use the `hacker` VM to exploit a [broken access control (BAC)](https://owasp.org/Top10/A01_2021-Broken_Access_Control/) vulnerability in the Juice Shop basket feature.

The Juice Shop web application was built by OWASP to demonstrate some of the most common web application vulnerabilities. I've picked an exploit I found on the official OWASP challenge solutions page: [Put an additional product into another user’s shopping basket](https://pwning.owasp-juice.shop/companion-guide/latest/appendix/solutions.html#_put_an_additional_product_into_another_users_shopping_basket)

There is a great [Hacksplained YouTube video walkthrough](https://www.youtube.com/watch?v=pdtDtmIiSOQ) and [a blog post](https://curiositykillscolby.com/2020/12/02/pwning-owasps-juice-shop-pt-37-manipulate-basket/) showing how to use the Burp Suite penetration testing tool to manipulate the API.

## How Does hacker exploit BAC?
First, `customer` adds a product to their basket, like apple juice. If you open the browswer's inspection tool, you can see the HTTP request being sent to the server is to `/api/BasketItems/` using the HTTP method `POST`. In the payload, the basket id is passed. This basket belong to the `customer` user. The request has a header providing user authorization. So if you simple changed the basket id to a basket belonging to another user, you would get the 401 Unauthorized error from the server.

When the user on `hacker` creates an account and tries to add a product to their basket, they see the HTTP requests being sent to the server. They can use Burp Suite's Interceptor tool to intercept the POST `/api/BasketItems/` request and send it to the Repeater tool.

When they try to change the `BasketId`, it returns an HTTP status code `401 Unauthorized`. But they can keep trying to manipulate that HTTP request so they get the `200 OK` HTTP status response.

But they keep trying. This time, sending two `BasketId`s, the first one being the basket id belonging to the `customer`, and the second belonging to the `hacker`. Now, they get the `200 OK`. They can keep repeating this using the Burp Suite Repeater tool, adding almost any product they want.

And if you check the basket belongong to the user on `customer`, the item has been added.


## customer Email To sysadmin
And so now, the `customer` wakes up, opens their computer, goes to the Juice Shop website to checkout their basket and finds products that they never added:

So `customer` sends this email to the `sysadmin`:

```
From: customer
To: sysadmin

Dear Juice Shop,

I'm a hug fan of your website.
I love drinking juice.
But I just found a bunch of 
products added to my basket!
I didn't put it in my basket.
I've been hacked.
I have been a loyal customer.
Please fix this!

Sincerely,
Juice Fan
```

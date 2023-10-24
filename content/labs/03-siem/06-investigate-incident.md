---
title: 06 Investigate Incident
type: docs
---

On the `soc-analyst` machine, I log into the `splunk` web interface, using the "soc-analyst" user account. With this "user" role, they can search for events and save searches.

## Message From sysadmin to soc-analyst
The `sysadmin` got an email from `juicefan` about their account getting hacked. Someone put a $3000 bike in `juicefan`'s basket. Now, `sysadmin` would like `soc-analyst` to investigate what happened:
```
From: sysadmin
To: soc-analyst

We've got a user with the email:
juicefan@example.com

They had the $3000 bike
added to their basket
without their permission.
Can you find more info about this?

Thanks
```

## Check Splunk Logs
So I know the incident involved putting a product in someone else's basket.

From the `soc-analyst` desktop, I log into the `splunk` web server with the user account "soc-analyst" that was created by `sysadmin`, and search for "basket" in the `juiceshop` index with `index="juiceshop" *basket*`.

### Interpreting HTTP Requests
There are some `GET /rest/basket/` and `POST /rest/BasketItems/` HTTP requests. The `juiceshop` web application is a "single page application". When the user interacts with it, by clicking the "Add to Basket" button or "liking" a review, the whole page doesn't reload.
![rest example](../rest-example.png)

Individual requests are made from the user's browser to the `pfsense` firewall server, forwarded the `juiceshop` web server, and get handled by the Juice Shop web application in `/opt/juice-shop`.
![source code](../source-code.png)

The different methods, like `GET` and `POST`, are used to communicate to the Juice Shop web application so it knows how to handle the request.

The `POST /api/BasketItems/` is a request to create a `BasketItem`, with a payload that's not shown in the log.

The `GET /rest/basket/7` is a request to get the `basket` with the id 7.

When the user adds to their basket, their browser sends the `POST /api/BasketItems/` request, and a second later, they send a `GET /rest/basket/{basketId}` request for all the basket items in the basket with that `basketId`.

If I change the Splunk search query from `index="juiceshop" *basket*` to `index="juiceshop" "POST /api/BasketItems/"`, I can see all the requests that created a `BasketItem`:
![post basketitems](../post-basketitems.png)

These HTTP events give the source IP address for all the `POST /api/BasketItems/` request (meaning, all the requests from users to put basket items in baskets) that the Juice Shop web application received.

There is an interesting entry. The other requests to add basket items had the `HTTP 200` response. Meaning, they were successful. But there were a few `HTTP 401` responses here:
![401 responses](../401-responses.png)

And `HTTP 401` is used when the client/user lacks valid authentication credentials. [Unauthorized](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/401).

It could be a bug in the code, so I'll check with the web application's database. See when the $3000 bike was added to `juicefan`'s basket.

## Investigate Basket Data In juiceshop Database
I use the `juiceshop` user account that `sysadmin` created for `soc-analyst` to SSH into `juiceshop`. I'm able to go into the `/opt/juice-shop` directory, because I'm in the `juiceshop` group.

In the `/opt/juice-shop/data` directory is the SQLite database `juiceshop.sqlite`. I use the `sqlite3` application to connect to the database.
![soc ssh](../soc-ssh.png)

The user that had the bike product put in their basket has the email `juiceshop@example.com`, so I use SQL to query the `createdAt` date for all the BasketItems in their Baskets, joined with the data from the Products table:
```sql
SELECT 
    BasketItems.createdAt,
    Products.name,
    Products.price
FROM 
    Users
JOIN 
    Baskets ON Users.id = Baskets.UserId
JOIN 
    BasketItems ON Baskets.id = BasketItems.BasketId
JOIN 
    Products ON BasketItems.ProductId = Products.id
WHERE 
    Users.email = 'juicefan@example.com';
```

This returned:
```
2023-10-24 16:29:07.675 +00:00|Apple Pomace|0.89
2023-10-24 16:29:08.641 +00:00|Apple Juice (1000ml)|1.99
2023-10-24 16:38:20.411 +00:00|Melon Bike (Comeback-Product 2018 Edition)|2999
```

So the expensive bike was added on `October 24, 2023 16:38:20`, in UTC time. That would be 

If I look go back to the logs in Splunk, that is when the `HTTP 200` response occurred after a few `HTTP 401` attempts.
![200 success](../200-success.png)

And it looks like the IP address used is `192.168.122.181`.

## Save Splunk Search
Next, I search the `juiceshop` index for the IP address associated with the incident, `192.168.122.181`, with `All Time` as the time range, and save it as `Potential Malicious Juicer` and add a short description. If there's an incident number, I add it.
![saved search](../saved-search.png)

Next, I'll report what I found to the `sysadmin`, and give suggestions about what can be done to prevent this from happening again.


## Immediate Actions
The `soc-analyst` sends this message to `sysadmin`:
```
Hi. It looks like the user at 192.168.122.181 
expoited a broken access control by 
manipulating an HTTP POST, 
adding a product to the 
"juicefan@example.com" account.

I suggest configuring the pfsense firewall server to
blocking that IP address ASAP.

The juiceshop source code
should be reviewed, specifically code that 
handles the REST API for basket items:
/opt/juice-shop/routes/basketItems.ts
```
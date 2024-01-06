---
title: 04 Basket Stuffing Investigation
type: docs
---

On the `soc-analyst` machine, I log into the `splunk` web interface, using the "soc-analyst" user account. With this "user" role, they can search for events and save searches.

## Message From sysadmin to soc-analyst
The `sysadmin` got an email from `customer` about their account getting hacked. Someone put a $3000 bike in `customer`'s basket. Now, `sysadmin` would like `soc-analyst` to investigate what happened:
```
From: sysadmin
To: soc-analyst

We've got a user with the email:
customer@example.com

They had products
added to their basket
without their knowledge.
Can you find more info about this?

Thanks
```

## Check Splunk Logs
So I know the incident involved putting a product in someone else's basket.

From the `soc-analyst` desktop, I log into the `splunk` web server with the user account "soc-analyst" that was created by `sysadmin`, and search for "basket" in the `juicero` index with `index="juicero" *basket*`.

### Interpreting HTTP Requests
There are some `GET /rest/basket/` and `POST /rest/BasketItems/` HTTP requests. The `juicero` web application is a "single page application". When the user interacts with it, by clicking the "Add to Basket" button or "liking" a review, the whole page doesn't reload.

Individual requests are made from the user's browser to the `pfsense` firewall server, forwarded the `juicero` web server, and get handled by the Juice Shop web application in `/opt/juice-shop`.

The different methods, like `GET` and `POST`, are used to communicate to the Juice Shop web application so it knows how to handle the request.

The `POST /api/BasketItems/` is a request to create a `BasketItem`, with a payload that's not shown in the log.

The `GET /rest/basket/7` is a request to get the `basket` with the id 7.

When the user adds to their basket, their browser sends the `POST /api/BasketItems/` request, and a second later, they send a `GET /rest/basket/{basketId}` request for all the basket items in the basket with that `basketId`.

If I change the Splunk search query from `index="juicero" *basket*` to `index="juicero" "POST /api/BasketItems/"`, I can see all the requests that created a `BasketItem`.

These HTTP events give the source IP address for all the `POST /api/BasketItems/` request (meaning, all the requests from users to put basket items in baskets) that the Juice Shop web application received.

There is an interesting entry. The other requests to add basket items had the `HTTP 200` response. Meaning, they were successful. But there were a few `HTTP 401` responses here:

And `HTTP 401` is used when the client/user lacks valid authentication credentials. [Unauthorized](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/401).

It could be a bug in the code, so I'll check with the web application's database. See when the $3000 bike was added to `customer`'s basket.

## Investigate Basket Data In juicero Database
I use the `soc-analyst` user account that `sysadmin` created for the SOC team to SSH into `juicero`. I'm able to go into the `/opt/juice-shop` directory, because I'm in the `juicero` Linux group.

In the `/opt/juice-shop/data` directory is the SQLite database `juicero.sqlite`. I use the `sqlite3` application to connect to the database.

The user that had the bike product put in their basket has the email `juicero@example.com`, so I use SQL to query the `createdAt` date for all the BasketItems in their Baskets, joined with the data from the Products table:
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
    Users.email = 'customer@example.com';
```

This returned:
```
2023-10-24 16:29:07.675 +00:00|Apple Pomace|0.89
2023-10-24 16:29:08.641 +00:00|Apple Juice (1000ml)|1.99
2023-10-24 16:38:20.411 +00:00|Melon Bike (Comeback-Product 2018 Edition)|2999
```

So the expensive bike was added on `October 24, 2023 16:38:20`, in UTC time. That would be 

If I look go back to the logs in Splunk, that is when the `HTTP 200` response occurred after a few `HTTP 401` attempts.

And it looks like the IP address used is `192.168.122.181`.

## pfsense Packet Capture
When I creted an account for `soc-analyst` on the `pfsense` firewall server, I gave the user access to the Packet Capture feature on the web GUI for pfsense, webConfigurator. The feature provides a user interface for setting up the packet capture software `tcpdump`, and can monitor different interfaces on the `pfsense` server.

For the purpose of gathering evidence of the data being transmitted by this suspicious user at IP `192.168.122.181`, I can login to the `pfsense` server at `https://192.168.3.1`, open the Diagnistics > Packet Capture page, and start configuring a filter for the traffic. I know it will be using the TCP protocol, involving the suspicious IP address, and come through the `WAN` interface (aka the `vtnet0` interface on `pfsense`).

I can edit those fields in the Packet Capture and Custom Filter sections. Then, I click start. The traffic matching those will appear in the "Packet Capture Output" large text field. It's saved as a `.pcap` file in the `pfsense` temporary directory.

The `tcpdump` command that this user interface uses is:
```
/usr/sbin/tcpdump -ni vtnet0 -c '1000' -U -w - '((host 192.168.122.120) and (tcp)) and ((not vlan))'
```

## Repeat Exploit From hacker VM
Using the `hacker` VM, I can use the Burp Suite Repeater tool to send the same `POST` request using two basket id numbers, adding a product to the `customer` basket. This will be included in the packets captured on `pfsense`.

## Analyze pcap File With Wireshark
Using the `soc-analyst` VM, I can stop the packet capture, and click the "Download" button. This saves the `.pcap` file. I can then find the file in the Downloads directory and open it with a popular packet inspection software installed on Kali Linux called [Wireshark](https://www.wireshark.org/). It lets me look through the packets in an easy to view user interface.

I can view the individual packets, their source and destination IP addresses, and the content of the payload for `POST` requests. The payload being sent from the user's browser to the server is in `JSON` format. This is an easy to read object format.

I can filter the packets by the the packet attributes, like destination IP and protocol. To filter for just packets from the suspicious IP `192.168.122.120` using the HTTP method `POST` that is in `JSON` format, I can enter this in the filter field:
```
ip.src == 192.168.122.120 && (http.request.method == "POST") && (http contains "Content-Type: application/json")
```

These represent the client, in this case the `hacker` VM, telling the server, in this case the Juice Shop web application running on the `juicero` VM (via port forwarding on the `pfsense` VM) to create basket items. Under the "JSON Object Notation" field, you can see the payload being sent.

When `hacker` was using the Burp Suite Repeater tool to bypass the `401 Unauthorized` responses, they used the "HTTP paramater pollution". They passed two basket ids in a single `POST` request payload. This shouldn't be possibe if they used the normal user interface of clicking the "Add To Basket" button.

To see how the server responded to a `POST` request, you can right click the packet and select "Follow > HTTP Stream". This opens a window showing the HTTP request and the HTTP response. When `hacker` was first attempting, some of the responses were were `401 Unauthorized`. But then they were able to get a `200 OK` response. This meant the basket item was created. The response included the new basket item object, with the basket id being the one belonging to `customer`, not `hacker`. These packets can be included in the report, and can help developers understand how to fix the vulnerability.

## Save Splunk Search
Next, I search the `juicero` index for the IP address associated with the incident, `192.168.122.181`, with `All Time` as the time range, and save it as `Potential Malicious Juicer` and add a short description. If there's an incident number, I add it.

Next, I'll report what I found to the `sysadmin`, and give suggestions about what can be done to prevent this from happening again.


## Immediate Actions
The `soc-analyst` sends this message to `sysadmin`:
```
Hi. It looks like the user at 192.168.122.181 
expoited a broken access control by 
manipulating an HTTP POST, 
adding a product to the 
"customer@example.com" account.

I suggest configuring the pfsense firewall server to
blocking that IP address ASAP.

The juicero source code
should be reviewed, specifically code that 
handles the REST API for basket items:
/opt/juice-shop/routes/basketItems.ts

```
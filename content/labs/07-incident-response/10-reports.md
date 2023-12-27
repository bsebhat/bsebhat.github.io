---
title: 10 Reports
type: docs
---

## Report To sysadmin
Incident: User put $2999 bike in another users basket

### Incident Summary:
- The basket belonged to user customer@example.com (UserId: 22)
- The product was the Melon Bike (ProductId: 33, Price: 2999)
- The suspect used the IP address 192.168.122.181
- There were 3 attempts over less than 3 minutes to put the product in the user's basket, each receiving a HTTP 401 error
- The 4th attempt was successful
- The product was added to the basket at October 24, 2023 16:38:20 UTC

### Investigation:
The user contacted `sysadmin` with an email saying they found the product and never put it in their basket.

I was contacted by `sysadmin` to investigate the incident. I searched the Splunk juiceshop index for mentions of "basket", then "POST /api/BasketItems/", because I was looking for requests to put basket items in baskets.

I found some suspicious requests that received "HTTP 401" error codes. I then used my soc-analyst account on the `juiceshop` web server to SSH in and search the SQLite database at `/opt/juice-shop/data/juiceshop.sqlite`.

I used this SQL query to retrieve the product names for all of the basket items and the time they were put in the user's basket:
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

That returned these results:
```
2023-10-24 16:29:07.675 +00:00|Apple Pomace|0.89
2023-10-24 16:29:08.641 +00:00|Apple Juice (1000ml)|1.99
2023-10-24 16:38:20.411 +00:00|Melon Bike (Comeback-Product 2018 Edition)|2999
```

Going back to the Splunk event log for the juiceshop index, I found the POST command to "/api/BasketItems" that matched the time the bike was added to the user's basket, October 24, 2023 16:38:20 UTC.

I searched for all event logs in the juiceshop for the IP address used to add that basket item, 192.168.122.181, and saved it as "Potential Malicious Juice".

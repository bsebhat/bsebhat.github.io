---
title: 03 Security Analysis
type: docs
---

The current lab involves two servers working together to provide users on the default virtual network access to the juice-shop website. The `pfsense` VM acts as a firewall and gateway between the internal isolated subnets (`LAN`, `DMZ`, and `SOC`) from the `default` network. 

The `pfsense` server receives HTTP traffic on port 80, and redirects that traffic to the `juicero` at port 3000. The NodeJS juice-shop web app receives the traffic on port 3000, and responds to the request based on the URL path and the payload sent.

## juicero
One major asset is the `juicero` web server with CentOS Stream 9 operating system installed. It has the juice-shop web application running on a systemd service, and the NodeJS code for the web application is located at `/opt/juice-shop`. In addition to the root account, it has a vmadmin user account with sudo privileges. When the user on `sysadmin` needs to manage the web application on `juicero`, they use the SSH service to login as the vmadmin account. 

### juice-shop NodeJS Web App
It is a NodeJS web application that uses the ExpressJS backend web framework and Angular frontend framework.  several deprecated libraries It's a  The log data for the web app is at `/opt/juices-shop/logs`. When clients access the NodeJS server, their HTTP requests are logged in access logs. 

### juice-shop Database
The database used is sqlite, and is located at `/opt/juice-shop/data/juicero.sqlite`. It has the following tables:
```
TODO: list database tables
```

### juice-shop Access Logs
When you go on the `customer` VM to access the Juice Shop web application via the `pfsense` WAN interface, that web traffic is logged in the `/opt/juice-shop/logs` directory as log files. The application is configured to save the log data in timestamped log files. The client IP address is logged, with the URL and HTTP method used, the time of the request, the browser used by the client, as well as the HTTP status code.

Because the Juice Shop web application is a "single-page app", the requests being sent to the server won't match the URL you see in the browser address bar. When a user first accesses the web app, a lot of code will be  The client-side code will react to the user interactions, change the route path, and send various HTTP requests to the server to get data 

For example, when the `customer` VM opens a web browser for the first time and accesses the `pfsense` WAN interface with the URL `http://pfsense`, a lot of client-side code is downloaded and it takes a few seconds. If you check the end of today's log file at `/opt/juice-shop/logs`, the following access log entries are entered in a log file:
```
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /rest/admin/application-configuration HTTP/1.1" 200 - "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /rest/admin/application-version HTTP/1.1" 200 20 "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /rest/admin/application-configuration HTTP/1.1" 304 - "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /rest/admin/application-version HTTP/1.1" 200 20 "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /rest/admin/application-configuration HTTP/1.1" 200 - "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /rest/admin/application-configuration HTTP/1.1" 200 - "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /rest/admin/application-configuration HTTP/1.1" 200 - "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /rest/languages HTTP/1.1" 200 - "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /rest/products/search?q= HTTP/1.1" 200 - "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /api/Challenges/?name=Score%20Board HTTP/1.1" 200 648 "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /api/Challenges/?name=Score%20Board HTTP/1.1" 200 648 "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /api/Quantitys/ HTTP/1.1" 200 - "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:33:19 +0000] "GET /rest/admin/application-configuration HTTP/1.1" 304 - "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
```

But when the user clicks the "Customer Feedback" link on the left menu, the following log entries are added:
```
::ffff:192.168.122.238 - - [26/Dec/2023:00:36:49 +0000] "GET /rest/user/whoami HTTP/1.1" 200 11 "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
::ffff:192.168.122.238 - - [26/Dec/2023:00:36:49 +0000] "GET /rest/captcha/ HTTP/1.1" 200 46 "http://pfsense/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
```

So using the access logs to determine how a user has interacted with the web application will be a little tricky. It will require knowlede of the frontend and backend code, and using the app to see how user interaction corresponds to API calls. Then, the API calls can be documented so that SOC team members can interpret network traffic logs as user actions when investigating possible security incidents.

For example, when a user clicks the "Add to Basket" button for the apple juice product, there are several HTTP request to the server:
1. `GET /rest/basket/6`: This requests the contents (basket items) of the basket with id 6 (the basket belonging to the current user).
2. `POST /api/BasketItems/`: This is used to create a "basket item". In the payload being sent, there are three items: BasketId: 6 (the user's basket), ProductId: 1 (the apple juice), and quantity: 1 (1 apple juice is being added to the basket). The server receives this request and adds the product to the basket for the quantity, creating a basket item.
3. `GET /api/Products/1?d=Tue Dec 26 2023`: This gets the product information for the product that was added (apple juice).
4. `GET /rest/basket/6`: This gets the data for the basket with id 6. The data returned includes a list of basket items in that basket. Including the new basket item that was created for the apple juice.

Simple user interactions generate multiple HTTP requests, which a seperate API calls that send information to the server and request information, updating the web application and allowing the user to see their basket update immediately with new basket items. The access log data that records actions performed by users will describe the various HTTP GET, POST, or PUT requests going from client to server, with id numbers, rather than the higher-level business logic like "add apple juice to basket".

## pfSense Firewall Server
The `pfsense` server has multiple interfaces, connecting to the `LAN`, `DMZ`, and `SOC` isolated virtual networks. It provides DNS and DHCP services, and acts as a firewall between the networks and the `default`/`WAN` virtual network.

It comes with a web admin interface called the webConfigurator. It can be accessed via HTTPS from any of the three interace IP addresses: `192.168.1.1`, `192.168.2.1`, or `192.168.3.1`.

In addition to the root account with full privileges, you can create other users and groups and give them access to specific features. This can help allow users other than the highest systems administrator access to the services and log data available on `pfsense`. This can help them monitor

You can also use a Suricata service on `pfsense` and configure it through the webConfigurator. They can block certain traffic based on HTTP content, or generate alerts. Those alerts can also be viewed from the pfsense webConfigurator.
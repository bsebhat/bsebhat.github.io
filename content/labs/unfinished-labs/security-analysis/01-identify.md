---
title: 01 Identify
type: docs
---

In order to secure the Juice Shop web application, we need to spend time understanding what it is. It's not just code. It's assets, data, functions. Critical business operations. 

Identifying what needs to be secured and monitored will help later when determining how to protect Juice Shop. If you just think of it as an e-commerce website, it can be difficult to determine where to start. I'll use the NIST Cybersecurity Framework as a guide.

## Critical Assets and Processes
I'm going to identify the most important assets and processes used by the Juice Shop web application.

### The juiceshop Server
Looking at the current network diagram, one of the most important assets is the web server that runs the Juice Shop web application, `juiceshop`.
![diagram](../../../labs/diagrams/firewall.drawio.png)

#### Operating System
The `juiceshop` server has Arch Linux installed

#### Network Interface
It's on the LAN isolated network, along with the `sysadmin` Linux desktop machine. It's assigned the static IPv4 address `192.168.1.21/24`.

#### Other Network Services
The OpenSSH server is running, available on port 22. It's used by the `sysadmin`, who logs in as vmadmin.

#### Users
The `juiceshop` server has only two users: vmadmin and root. They both have sudo privilege. The root user is used to run the systemd service `juice-shop`.

### The Juice Shop Web Application Source Code
After reviewing the source code located in `/opt/juiceshop`, I have a better idea of the digital assets.

The source code for the Juice Shop app was cloned from the GitHub repository at [https://github.com/juice-shop/juice-shop](https://github.com/juice-shop/juice-shop). It's a NodeJS server application. Its backend is built with the Express framework, and its frontend uses Angular, with many other dependencies.

### Database
It uses two lightweight databases: a MarsDB that stores orders and reviews, and a SQLite database.

#### SQLite database
The tables in the SQLite database are:
```
Addresses          Challenges         Memories           SecurityAnswers  
BasketItems        Complaints         PrivacyRequests    SecurityQuestions
Baskets            Deliveries         Products           Users            
Captchas           Feedbacks          Quantities         Wallets          
Cards              ImageCaptchas      Recycles         
```

#### MarsDB database
The MarsDB has two collections: `posts` and `orders`. The orders contain lists of products. The MarsDB database currently has a Arbitrary Code Injection vulnerability that is considered ["Critical"](https://security.snyk.io/package/npm/marsdb) on the Snyk Vulnerability Database website. The NodeJS package had a health score of 30/10, and hasn't been updated in 7 years.

### User Inputs
There are many feature available to get input from the user. 

#### REST API
The user interface was developed as single page app (SPA). The Angular frontend code makes REST calls (GET, PUT, POST, DELETE) to the backend.

#### Entry Points For User Input
1. Customer Feedback: Users can submit feedback, both anonymous and whie logged in.
2. Login: Users can login with their usernames and passwords, or use a Google account to login using OAuth2.0
3. Register: Users can create an account with a username, password, and security question/answer.
4. Search: Users can search for products by name.
5. Products: The user can add products to their basket.
6. Reviews: The user can also post a review of a product.
7. Review Like: Users can also click a thumbs up icon next to a review to "like" it.
8. Basket: Users can see the products in their basket, and modify or remove the quantity of each item. They can also choose to checkout their basket products.
9. Address: Users can add an multiple addresses, and choose one when ordering products for delivery.
10. Support Chat: Support questions can be submitted with AI support agents.
11. Photo Wall: Users can submit image files to be displayed in a photo galary page.
12. Deluxe Membership: Users can purchase special memberships.
13. Payment: Multiple payment methods can be submitted, and used when checking out basket items.
14. Order Tracking: View delivery status for orders.
15. Request Data Export: Request form for user data export.
16. Request Data Erasure: Users can request to have data erased permanently, complying with General Data Protection Regulation (GDPR) laws.

### Library Dependencies
TODO: discuss dependencies

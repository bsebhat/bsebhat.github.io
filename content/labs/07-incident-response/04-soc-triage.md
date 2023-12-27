---
title: 04 SOC Triage
type: docs
---

So there are three incidents that need to be addressed:
1. Basket Stuffing: Someone has been able to add products in another user's basket.
2. Zero-Star Feedback: Someone was able to submit customer feedback with zero stars and not the minimum one star.
3. Confidential Docs: Someone accessed the confidential aquisitions document and released it online.

## Prioritize Response
Since the zero-star feedback won't affect business operations or corporate reputation, I think that is the lowest priority.

The basket stuffing will result in customers losing trust in the business, and may result in a lot of unwanted purchases if they checkout their baskets without checking. Untangling all the unwanted basket items would take a lot of time and resources. So this needs to be handled immediately.

The confidential docs getting leaked is also a huge problem, because some of the documents in the `/ftp` directory contain sensitive technical data that can be used in future attacks. Also, it seems like this is being used to share files with technical staff, and someone could be uploading new files thinking it's secure or undiscovered.

### Immediate Actions
1. Copy the `/ftp` folder contents to another server that is not publicly accessible, and delete it.
2. Investigate cause of basket stuffing that was reported. Determine the IP address, and block it.
3. Determine the vulnerability that allowed user to add item to another basket, and prevent it from happening again.

### Other Actions
1. Review access logs to see when clients downloaded aquisition document. Investigate IP addresses to see if one is unusual.
2. Review access logs for any other downloads from `/ftp` directory. Investigate unusual IP addresses.
3. Improve server-side input validation for customer feedback so zero-star feedback is invalid.

Then, send a message to all employees that they should never use the `juiceshop` web server to host and share files that they do not want publicly viewed. We will have to plan another way to securely share files between staff, like an internal file server.

The next action is to 

---
title: 03 SOC Triage
type: docs
---

So there are three incidents that need to be addressed:
1. Basket Stuffing: Someone has been able to add products in another user's basket.
2. Zero-Star Feedback: Someone was able to submit customer feedback with zero stars and not the minimum one star.

## Prioritize Response
Since the zero-star feedback won't affect business operations or corporate reputation, I think that is the lowest priority.

The basket stuffing will result in customers losing trust in the business, and may result in a lot of unwanted purchases if they checkout their baskets without checking. Untangling all the unwanted basket items would take a lot of time and resources. So this needs to be handled immediately.

### Immediate Actions For Basket Stuffing (Do ASAP)
1. Investigate cause of basket stuffing that was reported. Determine the IP address, and block it.
2. Determine the vulnerability that allowed user to add item to another basket, and prevent it from happening again.

### Not Urgent Actions For Zero-Star Feedback
Improve server-side input validation for customer feedback so zero-star feedback submitted by REST API is flagged as invalid input.
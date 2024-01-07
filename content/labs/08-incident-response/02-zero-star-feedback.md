---
title: 02 Zero-Star Feedback
type: docs
---

The [zero-star feedback](https://pwning.owasp-juice.shop/companion-guide/latest/appendix/solutions.html#_give_a_devastating_zero_star_feedback_to_the_store) exploitation involves the [improper data validation](https://owasp.org/www-community/vulnerabilities/Improper_Data_Validation) vulnerability.

The customer feedback form allows users to submit feedback and a rating between 1 and 5 stars. The form has UI code that disables the submit button if the rating isn't between 1 and 5 stars.

But it's very easy for the user on `hacker` to just open their browser's developer tools and delete the `disabled` attribute for the submit button. Then, they can submit the feedback with zero stars.

When the admin goes through the customer feedback, the notice one has zero-stars. Since this shouldn't be possible, they send the SOC team an email:
```
Hi, I just saw an anonymous customer feedback 
with 0 stars. That's not supposed to be possible.
What happened?
-admin
```
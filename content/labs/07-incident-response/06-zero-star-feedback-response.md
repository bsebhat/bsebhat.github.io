---
title: 06 Correct Feedback Validation
type: docs
---

## Report to sysadmin
The zero-star feedback incident was considered low-priority. That's because it didn't really affect customer data, reputation, and it couldn't potentially cost the company money.

A user was able to submit anonymous customer feedback with a zero-star rating. This was disabled by the user interface code on the client-side. But, recently, the feedback was found on the admin panel with zero stars.

## Investigation
While investigating the feedback form user interface, it appears the only thing restricting zero-star ratings is the disable submit button. This could be bypassed by editing the form HTML using browser developer tools included in most popular web browsers.

There was no validation stopping the feedback from being created by the server. It was just the user interface form. Because popular penetration tools like Burp Suite make it easier to bypass user interface and easily send custom made HTTP requests to REST API service, I think this minor incident can be used as a warning that there needs to be more emphasis on securing the API itself. It's not enough to rely on user interface validation and access controls.

## Solution
I think a good solution is to increase usage of the backend validation features provided by ExpressJS. For this incident, a `Feedback` model is used. It has the `rating` integer field, but no validation that it's value is between 1 and 5. 

To create backend validaton of customer feedback data, you can add a few lines of code to the typescript file at `/opt/juice-shop/models/feedback.ts`:
```typescript
const FeedbackModelInit = (sequelize: Sequelize) => {
    Feedback.init(
{
....
rating: {
  type: DataTypes.INTEGER,
  allowNull: false,
  /** validate ratings minimum 1 and maximum 5 **/
  validate: {
    min: 1,
    max: 5
  },
  set (rating: number) {
    this.setDataValue('rating', rating);
        challengeUtils.solveIf(challenges.zeroStarsChallenge, () => {
    return rating === 0
    })
  }
  ....
}

```

I suggest a review of all data models used by the app, and validation requirements to be reviewed and have clear documentation. Then, developers can work on modifying the backend code to ensure error messages are clear and integrated with the user interface. Testing should also be done with both the user interface and the API calls to ensure access controls are consistent and can't be bypassed with tools like Burp Suite.
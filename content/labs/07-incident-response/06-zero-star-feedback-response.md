---
title: 06 Correct Feedback Validation
type: docs
---

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
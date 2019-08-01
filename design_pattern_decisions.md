# Design pattern decisions

## **Commit/Reveal**
The Voting mechanism here is intended to harnesses the "Wisdom of Crowd". Three Conditions essential to its result are :-

- Diversity of opinion: Each person should have private information even if it’s just an eccentric interpretation of the known facts.
- Independence: People’s opinions aren’t determined by the opinions of those around them.
- Decentralization: People are able to specialize and draw on local knowledge.any cognitive biases negatively impact its efficacy, and lead to undesirable consequences such as bandwagoning and groupthink.

If any of these fails to apply, it could result in many cognitive biases negatively impact its efficacy, and lead to undesirable consequences such as bandwagoning and groupthink.

## **Expiration Period**

Implemented to ensure payouts always occurred, even for abandoned proposels and voters.
The temporary hacked-together solution is to run an expiration check modifier function if any action is attempted on an in-progress voting and review periods. Each is assigned during the contract deploy.

## **State Machine**
An enum is used to indicate what state the proposal, to determine which period is proposal in.

## **"Fail Early and Fail Loud"**
Contract uses modifier and require() statements wherever possible, as the first execution in the function logic.

## **Restricting Access**
Contract is very selective design with what state variables are publicly readable, and what functions are publicly callable, and put checks in place to ensure the appropriate addresses (the admin) are the only ones who can call functions on the Created Proposal Contract.

## **Owner-only Functions**
I opted out of creating a selfdestruct function because I want users to trust that I won't run away with their in-escrow wagers. Whereas circuit breaker is implemented. Therefore, currently the proposal creater Prescience Main Contract can be paused while voting and review period is on ongoing, which could force the proposal to expire without users being able to take action.

## **Contract Simplicity and Readability**

I opted into writing Multiple contract to enhance the upgradablity feature. The Main contract allows to create other proposals which is fully commented and easy to analize. I would soo increase more readiblity and logical expansion of ideas under seperate wings and split it up into multiple inherited contracts for easier auditability.

## **Circuit Breaker**
The function owner can pause all action on the contract in case of an emergency. There is a situation here where proposal will still expire, but as the participants won't lose money in incentivize proposal. There is no threat to loosing the security deposit.

## **"Balance withdrawal" pattern**
To protect users from DoS attacks from malicious contracts, I've implemented this pattern to separate ether transfer logic from proposal logic.

## **Events**
Contract uses event listeners on the front end as a way to trigger UI value/state refreshing.
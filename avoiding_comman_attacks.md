# Avoiding common attacks

## Using `now` alias `block.timestamp`
The above contracts uses time based variables to calculate the proposal Review, Commit and Reveal period end. This is done using the `blockchain.timestamp` since there is no risk of being attacked with front-running methods and minners Influence over the `block.timestamp` doesn't affect the result. This wouldn't be an issue as Proposal is public and Review Period is prior to voting period doesn't imlfuence the outcomes, where time can be crucial.

```
reviewPhaseEndTime = block.timestamp + _ReviewPhaseLengthInSeconds;
commitPhaseEndTime = block.timestamp + _CommitPhaseLengthInSeconds + _ReviewPhaseLengthInSeconds;
revealPhaseEndTime = block.timestamp + _RevealPhaseLengthInSeconds + _CommitPhaseLengthInSeconds + _ReviewPhaseLengthInSeconds;
```

## Reentrancy attack
To avoid reentrancy attacks all method that are sending ether are written to execute send function at the very end of the method, after substracting balance variables.

## Overflow
In order to avoid overflow vulnerabilities in the contract for certain inputs including String and Int constant values and modifier character limitation have been set to a Threshold that can be used for specific variables. `SafeMath` library is used for every `uint` operation in the contract. 

```
uint256 constant public MAX_TIME_PERIOD = 10 * 24 * 60 * 60;                   // Limit of 10 Days

uint256 constant public MAX_SECURITY_DEPOSIT_ENTRY_FEE = 1 * 10 ** 18;         // 1 ether

uint constant public amount = 1 * 10**17;                                             /**> Threshold amount in wei as a deposit entry fee */
```
## Commit/Reveal Scheme

The Voting mechanism here is intended to harnesses the "Wisdom of Crowd". Three Conditions essential to its result are :-

- Diversity of opinion: Each person should have private information even if it’s just an eccentric interpretation of the known facts.
- Independence: People’s opinions aren’t determined by the opinions of those around them.
- Decentralization: People are able to specialize and draw on local knowledge.any cognitive biases negatively impact its efficacy, and lead to undesirable consequences such as bandwagoning and groupthink.

If any of these fails to apply, it could result in many cognitive biases negatively impact its efficacy, and lead to undesirable consequences such as bandwagoning and groupthink.

## Circuit Breaker

The contract owner is able to pause/unpause any action on the contract as an emergency stop-gap. As of right now, that does in fact mean that games can expire while the contract is paused.

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

## Forcibly Sending Ether to a Contract
As a `selfdestruct` function does not triggers `callback` function of a contract, a malicious agent can set the address of a vulnearble contract as `selfdestruct` target address, where funds are sent after destroying a contract. If contract logic would allow disallow a function to be called by using its `balance`, can allow malicious agents to send ether and access the disallowed function. 

To avoid this attack vector, the researchDAO contract does not uses `balance`, instead using storage variables to keep track of balances in contract logic.  

```
struct Member {
    uint256 shares;         // rDAO voting shares - voting power
    uint256 contribution;   // Checking who offered how much when joining
    bool exists;            // General switch to indicate if an address is already a member
}
mapping(address => Member) public members;   // Storing member details in a mapping
```
## Gas Limit DoS on a Contract via Unbounded Operations
Contract that has unforseeable long loops can suffer from gas limit problems. If a payout function for example would loop across unknown lenght of addresses, it may be multiple blocks in lenght. 

Example:

```
function payOut() {
    uint256 i = nextPayeeIndex;
    while (i < payees.length && msg.gas > 200000) {
      payees[i].addr.send(payees[i].value);
      i++;
    }
    nextPayeeIndex = i;
}
```
To avoid these pitfalls the researchDAO contract `does not include any looping functions` and all payouts happen to a fixed number of addresses for every execution.


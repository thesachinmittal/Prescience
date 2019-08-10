# ProposalEvaluation
*FreeEvaluation: Contract allows participants to write their review and vote for the success.*
## constructor

**Parameters:**
* topic `string`
* desc `string`
* docs `string`
* _ReviewPhaseLengthInSeconds `uint256`
* _CommitPhaseLengthInSeconds `uint256`
* _RevealPhaseLengthInSeconds `uint256`

## commitVote

**Parameters:**
* _voteCommit `bytes32`

## revealVote

**Parameters:**
* upTechnical `uint256`
* downTechnical `uint256`
* upNonTechnical `uint256`
* downNonTechnical `uint256`
* choice `uint256`
* salt `string`

## conclusion
## getCount

**Parameters:**
* choice `uint`

**Return Parameters:**
* count `uint`
## majority
**Return Parameters:**
* `uint256`

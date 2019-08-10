# IncentivizeProposalEvaluation
## FALLBACK
*Fallback function*

**Development notice:**
*Funds Collection here.*

## constructor

**Parameters:**
* topic `string`
* desc `string`
* docs `string`
* _ReviewPhaseLengthInSeconds `uint256`
* _CommitPhaseLengthInSeconds `uint256`
* _RevealPhaseLengthInSeconds `uint256`
* _threshold `uint256`
* _reward `uint256`

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

**Parameters:**
* _reviewEndTime `uint256`

## winnersReward
## endProposal
## getCount

**Parameters:**
* choice `uint`

**Return Parameters:**
* count `uint`
## majority
**Return Parameters:**
* `uint256`

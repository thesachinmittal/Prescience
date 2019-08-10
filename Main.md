# Main
## constructor
*Address of the Contract Owner is assigned*
## Proposal

**Parameters:**
* topic `string`
* desc `string`
* docs `string`
* _ReviewPhaseLengthInSeconds `uint256`
* _CommitPhaseLengthInSeconds `uint256`
* _RevealPhaseLengthInSeconds `uint256`

## incentivizeProposal

**Parameters:**
* topic `string`
* desc `string`
* docs `string`
* _ReviewPhaseLengthInSeconds `uint256`
* _CommitPhaseLengthInSeconds `uint256`
* _RevealPhaseLengthInSeconds `uint256`
* _securityDeposit `uint256`
* _Reward `uint256`

## getProposalDetails

**Parameters:**
* Id `uint256`

**Return Parameters:**
* `address`
* `address`
* `string`
* `string`
## getProposalDetailsByAddress

**Parameters:**
* Contract `address`

**Return Parameters:**
* `address`
* `string`
* `string`
* `string`
## getIncentivizedProposal

**Parameters:**
* Id `uint256`

**Return Parameters:**
* `address`
* `address`
* `string`
* `string`
## getIncentivizedProposalByAddress

**Parameters:**
* Contract `address`

**Return Parameters:**
* `address`
* `string`
* `string`
## getProposalAddress

**Parameters:**
* Id `uint256`

**Return Parameters:**
* `address`
## getIncentivizedProposalAddress

**Parameters:**
* Id `uint256`

**Return Parameters:**
* `address`
## circuitBreaker
## circuitMaker
## checkLimits

**Parameters:**
* _ReviewPhaseLengthInSeconds `uint256`
* _CommitPhaseLengthInSeconds `uint256`
* _RevealPhaseLengthInSeconds `uint256`

**Return Parameters:**
* `bool`

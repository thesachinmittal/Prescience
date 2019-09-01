<p align="center">
  <img src="./src/images/Icon_Classic.jpg" align="center">
</p>

<div align="right">


</div>

## What does your project do?

### Original vision of Prescience
- Leveraging crowd wisdom to hit schelling point and find the TRUTH.

### Motivation
- Story of bitcoin and cyberpunk


### Aim

Prescience is aimed to become a DAO (Decentralized Autonomous Organisation) for researchers, Students and Investors. It will provide a decentralized market research platform where everyone can get 100% objectively fair reviews, voting for their next multi-million dollar idea. 
<br>
Since the aim is complex, and scope of project is much bigger and ask for bigger commitments. For this program, I have build basic functionalities and specifications with SCRATCH.

## How to set it up

#### Prerequisites

Ensure you have Truffle, Ganache, and NPM installed on your machine. Use Google Chrome as your browser, and ensure you have the MetaMask extension installed in it.

#### Setup local development instance

* Clone the project locally
```
git clone https://github.com/sanchaymittal/Prescience
cd Prescience
```

* Start local development blockchain and copy the mnemonic to be used later
```
ganache-cli
```

* Compile contracts and migrate them to the blockchain
```
npm install
truffle compile
truffle migrate
```

##### Setup the frontend
The frontend is a lite-server app to interact with the contract.

```
npm run dev
```

### Run Tests
```
truffle test
```

### Initial setup

- Goto [localhost:3000](http://localhost:3000) and login into metamask using the mnemonic obtained from ganache.
- Allow connecting the app to web3
- Owner's account will be already created and will be the one who initiated the contract.
- You can then switch to a different metamask account and create Proposal and interact with it. etc.

## Tech Stack and Additional Services

### IPFS
IPFS has been used to store the content of a specefic course. IPFS provides with a distributed file storage capability and easily fits into the platform. However, a non-IPFS based course content is also allowed in the platform.

## Tech Stack

**Frameworks/Tools**
  1. Truffle
  2. Ganache
  3. Metamask
  4. Web3.js
  5. Oraclize
  6. npm
  7. Git
  
  
**Programming Languages**  
  1. Solidity
  2. Javascript
  3. HTML
  4. CSS


## Evaluation checklist

- [x] README.md
- [x] Screen recording [!!]
- [x] Truffle project - compile, migrate, test
- [x] Smart Contract Commented
- [x] Library use
- [x] Local development interface
    - [x] Displays the current ETH Account
    - [x] Can sign transactions using MetaMask
    - [x] App interface reflects contract state
- [x] 5 tests in Js or Sol
    - [x] Structured tests
    - [x] All pass
- [x] Circuit breaker/Emergency stop
- [x] Project includes a file called design_pattern_desicions.md / at least 2 implemented
- [x] avoiding_common_attacks.md and explains at least 3 attacks and how it mitigates
- [x] deployed_addresses.txt that indicates contract address on testnet
- [x] upgradeable design pattern
- [ ] One contract written in Vyper or LLL
- [x] IPFS
- [ ] uPort
- [ ] ENS
- [ ] Oracle

## Future Prospects

1. Reputation Model
2. User Authentication Verification
3. Investment Scheme (Stake or CrowdFunding)
4. System Token
5. Community Currators Rights Distribution.
6. Code of Conduct (Writing Reviews).
7. Open Discussion Forum (After Proposal Reveal Period).
8. Zksnarks Proposal Setting.
9. ERC721 Token Update Scheme.  


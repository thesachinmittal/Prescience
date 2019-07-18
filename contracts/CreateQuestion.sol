pragma solidity ^0.5.0;

import "./Question.sol";

contract CreateQuestion {

  address[] newContracts;

  ///@notice Question creation function
  ///@param topic
  ///@param desc
  ///@param docs
  ///@param reviewTime
  ///@param judgmentTime
  function createQuery(string memory topic, string memory desc,string memory docs, uint256 reviewTime, uint256 judgmentTime) public{
    address newContract = new Question(topic, desc, docs, reviewTime, judgementTime);
    newContracts.push(newContract);
    }

  }
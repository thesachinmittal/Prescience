pragma solidity ^0.5.0;

import "./Question.sol";

contract CreateQuestion {
  constructor() public {
  }

  ///@notice Question creation function
  ///@param Question String
  ///@param reviewTime
  ///@param judgmentTime
  function createQuery(string memory Question, uint reviewTime, uint judgmentTime) public{

  }


  //
  //Helper Function
  //


  function createContract (bytes32 name) private {
        address[] newContracts;

        address newContract = new Contract(name);
        //or
        // Question number = new Question(arg1,arg2,arg3);
        newContracts.push(newContract);
    }
}

///@author Sanchay Mittal

pragma solidity ^0.5.0;

import "./Escrow.sol";

contract CreateQuestion {

  /**
   *State Variables
   */

  ///@notice Owner's address
  address public owner;     //owner of the contract
  address[] newContracts;

  //
  //Constructor
  //

  constructor() public {
    owner = msg.sender;
  }

  ///@notice Question creation function
  ///@param topic
  ///@param desc
  ///@param docs
  ///@param reviewTime
  ///@param judgmentTime
  function createQuery(
    string memory topic,
    string memory desc,
    string memory docs,
    uint256 _ReviewPhaseLengthInSeconds,
    uint256 _CommitPhaseLengthInSeconds,
    uint256 _RevealPhaseLengthInSeconds) public{
    address newContract = new Escrow(topic, desc, docs, _ReviewPhaseLengthInSeconds, _CommitPhaseLengthInSeconds, _RevealPhaseLengthInSeconds);
    newContracts.push(newContract);
    }

  }
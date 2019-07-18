pragma solidity ^0.5.0;

import "./JLToken.sol";

contract Justice {
  address public owner;


  constructor(uint256 initialSupply) public{
    owner = msg.sender;
    JLToken(initialSupply);
  }
}

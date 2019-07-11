pragma solidity ^0.5.0;

import "./SignUp.sol";

contract LogIn is SignUp{

  event welcome(string indexed username);

  modifier verifyName(string memory _username){
    require (Hero[_username].access,"Hero Doesn't Exist");
    _;
  }

  ///@notice Reads Contract to find existing Contract.
  ///@dev
  ///@return
  function checkHero(string memory _username, bytes32 key)
  public
  verifyName(_username)
  returns(bool){
    emit welcome(_username);
    return true;
  }
}

pragma solidity ^0.5.0;

import "./SignUp.sol";

contract LogIn is SignUp{

  event welcome(string indexed username);

//   modifier verifyName(bytes32 _username){
//     require (Hero[_username].access,"Hero Doesn't Exist");
//     _;
//   }

//   modifier checkPassword(bytes32 _key){
//        require (Hero[username].key == encryption(_key),"Wrong Password");
//   }

  ///@notice Reads Contract to find existing Contract.
  ///@dev
  ///@return
  function checkHero(string memory _username, string memory _key)
  public
  returns(bool){
    bytes32 username = encryption(_username);
    require (Hero[username].access,"Hero Doesn't Exist");
    require (Hero[username].key == encryption(_key),"Wrong Password");
    emit welcome(_username);
    return true;
  }
}

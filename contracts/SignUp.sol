pragma solidity ^0.5.0;


contract SignUp {

  ///@notice Owner's address
  address public owner;

  struct Hero{
    string[12] username;
    address account;
  }

  mapping (uint => Hero) Heroes;

  function() external payable{
    revert("Please try Again");
  }

  constructor() public {
    owner = msg.sender;
  }

  event SuccesfulRegistration(string indexed _username);
  
  modifier checkAccountName(string memory _username){
    _;
  }
  


  ///@notice Addaccount registers new user to the platform
  ///@dev Register's Account which includes username(Character limit 12), Ethereum address
  /* Account should made a threshold token transaction of JL tokens. */
  ///@param _username identification of user.
  ///@param _address Ethereum Address of the user.
  function addAccount(string memory _username,address _address) public returns(bytes32) {  
  }
}

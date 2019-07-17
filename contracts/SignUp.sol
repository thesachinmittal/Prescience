///@author Sanchay Mittal
///@title SignUp
///@notice Add Account of the users to the platform.

pragma solidity ^0.5.0;

import "./JLToken.sol";

contract SignUp {

  /**
   *State Variables
   */

  // ///@notice Owner's address
  // address public owner;     //owner of the contract

  ///@notice Account Details
  struct Account{
    address account;        //Eth address linked to the registered account
    bool access;            //if true the account is registered on platform
    // uint256 Reputation;     //Reputation of a user.
    bytes32 key;
  }

  ///@notice Details of the user uniquely indentified from the username.
  mapping (bytes32 => Account) Hero;

  ///@notice Fallback function
  function() external payable{
    revert("Please try Again");
  }


  /**
   *Events
   */

  ///@notice emits username after Succesful Registration
  event SuccesfulRegistration(string indexed _username);

  /**
   *Modifiers
   */

  // ///@notice Checks the owner of the contract
  // modifier checkOwner(){
  //   require(msg.sender == owner,"Owner's Permission");
  //   _;
  // }

  ///@notice Check if the username is registered or not.
  modifier checkName(bytes32 _username){
    require (!Hero[_username].access,"Hero Exist, Please Choose another name");
    _;
  }

//   ///@notice verify the transaction caller using address.
//   modifier verifyCaller (address _address){
//     require (msg.sender == _address, "This one is a Registered Account");
//     _;
//   }

  ///@notice Refund the excess amount
  modifier checkValue(uint threshold) {
    _;
    uint amountToRefund = msg.value - threshold;
    msg.sender.transfer(amountToRefund);
  }


  //
  //Constructor
  //

  // constructor() public {
  //   owner = msg.sender;
  // }

  /**
   *Functions
   */

  ///@notice addAccount registers new user to this platform
  ///@dev Register's Account which includes username(Character limit 12), Ethereum address
  /* Account should made a threshold token transaction of JL tokens. */
  ///@param _name identification of user.
  ///@param _address Ethereum Address of the user.
  function addAccount(string memory _name,address _address, string memory _key)
  public
  checkName(encryption(_name))
  {
    bytes32 name = encryption(_name);
    // uint threshold = 1;
    // entryAmount(threshold);
    Hero[name].account = _address;
    Hero[name].access = true;
    Hero[name].key = encryption(_key);
    Hero[name].access = true;
    emit SuccesfulRegistration(_name);
  }


  //
  //Helper Functions
  //

  function encryption(string memory _key) internal pure returns(bytes32) {
	 return sha256(abi.encodePacked(_key));
	}

  ///@notice Entry Security deposit for interaction with Judgement Platform.
  ///@dev
  ///@param threshold minimum amount required to interact with platform.
  ///@return Success report
//   function entryAmount(uint threshold)
//   private
//   checkValue(threshold)
//   returns(bool){
//     require(msg.value > threshold, "Funds Insufficient");
//     msg.sender.transfer(threshold);
//   }
}
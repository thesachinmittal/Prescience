///@author Sanchay Mittal

pragma solidity ^0.5.0;


///@title SignUp: Registration of Participants on platform.
///@notice This contract allows to register a user by uniquely identifying with the help of username and address
contract SignUp {

  /**
   *State Variables
   */

  ///@notice Owner's address
  address public owner;     //owner of the contract

  enum Status{
    Void, Linked, Lock, Denied
  }

  ///@notice Account Details
  struct Account{
    address account;        //Eth address linked to the registered account
    Status status;            //if true the account is registered on platform
    // uint256 Reputation;  //Reputation of a user.
    bytes32 key;
  }

  ///@notice Details of the user uniquely indentified from the username.
  mapping (bytes32 => Account) Hero;

  ///@notice Fallback function
  ///@dev Funds Collection here.
  function() external payable{
  }


  /**
   *Events
   */

  ///@notice emits username after Succesful Registration
  event SuccesfulRegistration(string indexed _username);

  /**
   *Modifiers
   */

  ///@notice Checks the owner of the contract
  modifier checkOwner(){
    require(msg.sender == owner,"Owner's Permission");
    _;
  }

  ///@notice Check if the username is registered or not.
  modifier checkName(bytes32 _username){
    require (Hero[_username].status == Status.Void,"Hero Exist, Please Choose another name");
    _;
  }

   modifier maxLength(string memory _str){
    bytes memory convertedString = bytes(_str);
    require(convertedString.length < 12," Username Exceeds the length ");
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

  constructor() public {
    owner = msg.sender;
  }

  /**
   *Functions
   */

  ///@notice addAccount registers new user to this platform
  ///@dev Register's Account which includes username(Character limit 12), Ethereum address
  ///@param _name identification of user.
  ///@param _address Ethereum Address of the user.
  function addAccount(string memory _name,address _address, bytes32 _key)
  public
  checkName(encryption(_name))
  maxLength(_name)
  {
    bytes32 name = encryption(_name);
    // uint threshold = 1;
    // entryAmount(threshold);
    Hero[name].account = _address;
    Hero[name].status = Status.Linked;
    Hero[name].key = _key;
    emit SuccesfulRegistration(_name);
  }


  /**
   * Helper Functions
   */

  function encryption(string memory _key) internal pure returns(bytes32) {
	 return sha256(abi.encodePacked(_key));
  }

  // ///@notice Entry Security deposit for interaction with Judgement Platform.
  // ///@dev
  // ///@param threshold minimum amount required to interact with platform.
  // ///@return Success report
//   function entryAmount(uint threshold)
//   private
//   checkValue(threshold)
//   returns(bool){
//     require(msg.value > threshold, "Funds Insufficient");
//     msg.sender.transfer(threshold);
//   }

/**
 * LogIn Space
 */
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
  maxLength(_username)
  returns(bool){
    bytes32 username = encryption(_username);
    require (Hero[username].status == Status.Linked,"Hero Doesn't Exist");
    require (Hero[username].key == encryption(_key),"Wrong Password");
    emit welcome(_username);
    return true;
  }
}

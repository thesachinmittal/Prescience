pragma solidity ^0.5.0;


contract SignUp {

  ///@notice Owner's address
  address public owner;
  string username;

  struct Account{
    address account;
    bool access;
  }
  mapping (string => Account) Hero;

  function() external payable{
    revert("Please try Again");
  }


  //
  //Events
  //
  event SuccesfulRegistration(string indexed _username);

  //
  //Modifiers
  //

  ///@notice Checks the owner of the contract
  modifier checkOwner(){
    require(msg.sender == owner,"Owner's Permission");
    _;
  }

  modifier verifyName(string memory _username){
    require (!Hero[_username].access," Account Name Exists");
    _;
  }

  ///@notice verify the transaction caller using address.
  modifier verifyCaller (address _address){
    require (msg.sender == _address, "This one is a Registered Account");
    _;
  }

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



  //
  //Functions
  //

  ///@notice Addaccount registers new user to the platform
  ///@dev Register's Account which includes username(Character limit 12), Ethereum address
  /* Account should made a threshold token transaction of JL tokens. */
  ///@param _name identification of user.
  ///@param _address Ethereum Address of the user.
  function addAccount(string memory _name,address _address) public returns(bytes32){
    uint threshold = 100;
    entryAmount(threshold);
    require(!Hero[_name].access,"Hero Exist, Please Choose another name");
    Hero[_name].account = _address;
    Hero[_name].access = true;
  }


  //
  //Helper Functions
  //

  ///@notice Entry Security deposit for interaction with Judgement Platform.
  ///@dev
  ///@param threshold minimum amount required to interact with platform.
  ///@return Success report
  function entryAmount(uint threshold)
  private
  checkValue(threshold)
  returns(bool){
    require(msg.value > threshold, "Funds Insufficient");
    msg.sender.transfer(threshold);

  }
}

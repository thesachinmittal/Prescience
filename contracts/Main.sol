///@author Sanchay Mittal

pragma solidity ^0.5.0;

import "./FreeEvaluation.sol";
import "./IncentiveEvaluation.sol";


contract Main {

  /**
   *State Variables
   */
  // Max Length of review, voting and reveal period.
  uint256 constant public MAX_TIME_PERIOD = 10 * 24 * 60 * 60;    // Limit of 10 Days

  uint256 constant public MIN_TIME_PERIOD  = 1 * 1 * 1 * 20;       // Limit of 20 Seconds

  // Max Limit for Security Deposit.
  uint256 constant public MAX_SECURITY_DEPOSIT_ENTRY_FEE = 1 * 10 ** 18;         // 1 ether

  // Pause
  bool public contractPaused = false;

  ///@notice Owner's address
  address public owner;     //owner of the contract
  mapping(address => bool) newContracts;


  modifier minTime(uint256 time){
    require(time >= MIN_TIME_PERIOD,"Increase the time Span");
    _;
  }

  modifier checkTimeLimit(uint256 time){
    require(time <= MAX_TIME_PERIOD,"Check the time period duration");
    _;
  }

  modifier checkSecurityDeposit(uint256 _securityDeposit){
    require(_securityDeposit <= MAX_SECURITY_DEPOSIT_ENTRY_FEE, "Entry Fee is too high");
    _;
  }

  modifier onlyOwner(){
    require(owner == msg.sender,"Owner's permission is required");
    _;
  }

    modifier checkIfPaused() {
    require(contractPaused == false," Contract is paused right now ");
    _;
  }

  //
  //Constructor
  //

  constructor() public {
    owner = msg.sender;
  }



  /** @notice Question creation function
   * @param topic Heading of the query
   * @param desc description of it.
   * @param docs docs related to it.
   * @param _ReviewPhaseLengthInSeconds Length of review period in seconds
   * @param _CommitPhaseLengthInSeconds Length of Commmit period in seconds
   * @param _RevealPhaseLengthInSeconds Length of reveal period in seconds
   */
  function free(
    string memory topic,
    string memory desc,
    string memory docs,
    uint256 _ReviewPhaseLengthInSeconds,
    uint256 _CommitPhaseLengthInSeconds,
    uint256 _RevealPhaseLengthInSeconds)
    public
    minTime(_ReviewPhaseLengthInSeconds)
    minTime(_CommitPhaseLengthInSeconds)
    minTime(_RevealPhaseLengthInSeconds)
    checkTimeLimit(_ReviewPhaseLengthInSeconds)
    checkTimeLimit(_CommitPhaseLengthInSeconds)
    checkTimeLimit(_CommitPhaseLengthInSeconds)
    checkIfPaused()
    {
    address _owner = msg.sender;
    FreeEvaluation newContract = new FreeEvaluation(_owner, topic,
     desc, docs, _ReviewPhaseLengthInSeconds, _CommitPhaseLengthInSeconds, _RevealPhaseLengthInSeconds);
    newContracts[address(newContract)] = true;
    // D newD = (new D).value(amount)(arg);
    }

    function incentive(
    string memory topic,
    string memory desc,
    string memory docs,
    uint256 _ReviewPhaseLengthInSeconds,
    uint256 _CommitPhaseLengthInSeconds,
    uint256 _RevealPhaseLengthInSeconds,
    uint256 _securityDeposit)
    public
    minTime(_ReviewPhaseLengthInSeconds)
    minTime(_CommitPhaseLengthInSeconds)
    minTime(_RevealPhaseLengthInSeconds)
    checkTimeLimit(_ReviewPhaseLengthInSeconds)
    checkTimeLimit(_CommitPhaseLengthInSeconds)
    checkTimeLimit(_CommitPhaseLengthInSeconds)
    checkSecurityDeposit(_securityDeposit)
    checkIfPaused()
    {
      address payable _owner = msg.sender;
    IncentiveEvaluation newContract = new IncentiveEvaluation(
      _owner, topic, desc, docs, _ReviewPhaseLengthInSeconds, _CommitPhaseLengthInSeconds, _RevealPhaseLengthInSeconds, _securityDeposit);
    newContracts[address(newContract)] = true;
    }


  // The contract owner can pause all functionality
    function circuitBreaker() public
    onlyOwner
    checkIfPaused{
    contractPaused = true;
  }

    // function incentive(address payable _address) public payable{
    //     require(newContracts[_address] == true, "Invalid address");
    //     Evaluation contractAddress = Evaluation(_address);
    //     contractAdress;
    // }

  }
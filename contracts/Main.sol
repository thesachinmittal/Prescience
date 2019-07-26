///@author Sanchay Mittal

pragma solidity ^0.5.0;

import "./FreeEvaluation.sol";
import "./IncentiveEvaluation.sol";


contract Main {

  /**
   *State Variables
   */

  ///@notice Owner's address
  address public owner;     //owner of the contract
  mapping(address => bool) newContracts;


  modifier minTime(uint256 time){
    require(time > 20,"Increase the time Span");
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
    minTime(_RevealPhaseLengthInSeconds){
    FreeEvaluation newContract = new FreeEvaluation(topic, desc, docs, _ReviewPhaseLengthInSeconds, _CommitPhaseLengthInSeconds, _RevealPhaseLengthInSeconds);
    newContracts[address(newContract)] = true;
    // D newD = (new D).value(amount)(arg);
    }

    function incentive(
    string memory topic,
    string memory desc,
    string memory docs,
    uint256 _ReviewPhaseLengthInSeconds,
    uint256 _CommitPhaseLengthInSeconds,
    uint256 _RevealPhaseLengthInSeconds)
    public
    minTime(_ReviewPhaseLengthInSeconds)
    minTime(_CommitPhaseLengthInSeconds)
    minTime(_RevealPhaseLengthInSeconds){
    IncentiveEvaluation newContract = new IncentiveEvaluation(topic, desc, docs, _ReviewPhaseLengthInSeconds, _CommitPhaseLengthInSeconds, _RevealPhaseLengthInSeconds);
    newContracts[address(newContract)] = true;
    // D newD = (new D).value(amount)(arg);
    }


    // function incentive(address payable _address) public payable{
    //     require(newContracts[_address] == true, "Invalid address");
    //     Evaluation contractAddress = Evaluation(_address);
    //     contractAdress;
    // }

  }
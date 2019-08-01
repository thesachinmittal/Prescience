///@title Prescience
///@author Sanchay Mittal
///@notice Prescience ...
///@dev All function calls are currently implemented without side effects

pragma solidity ^0.5.0;

///@notice Contract below interconnect with contract main for Proposal Creation.
///@dev ProposalEvaluation Contract operates without funding from Proposal Creater and IcenticizeProposal requires funding by proposal creater.
import "./ProposalEvaluation.sol";
import "./IncentivizeProposalEvaluation.sol";


contract Main {

  /**
   *State Variables
   */

  ///@notice Max Length of review, voting and reveal Period.
  uint256 constant public MAX_TIME_PERIOD = 10 * 24 * 60 * 60;                  /**> Limit of 10 Days */

  ///@notice Min Length of review, voting and reveal Period.
  uint256 constant public MIN_TIME_PERIOD  = 1 * 1 * 1 * 20;                    /**> Limit of 20 Seconds*/

  ///@notice Max Limit for Security Deposit Fee.
  uint256 constant public MAX_SECURITY_DEPOSIT_ENTRY_FEE = 1 * 10 ** 9;        /**> 1 ETHER or 1000000000000000000 wei or 1000000000 Gwei*/

  uint256 constant public MIN_SECURITY_DEPOSIT_ENTRY_FEE = 1 * 10 ** 5;        /**> 0.0001 ETHER or 100000000000000 wei or 100000 Gwei */

  uint256 constant public MAX_REWARD_LIMIT = 2 * 10 ** 9;                      /**> 2 ETHER or 2000000000000000000 wei or 2000000000 Gwei*/

  ///@notice Switch for Contract.
  ///@dev Only Contract Owner can change the value.
  bool public contractPaused = false;

  uint256 ProposalId;
  uint256 IncentivizeProposalId;

  ///@notice Owner's address
  address public owner;                                                         /**> owner of the contract*/

  ///@notice To check the Contract's address Existence.
  mapping(address => bool) ProposalContracts;
  mapping(address => bool) IncentivizeProposalContracts;

  ///@notice Array of Contract Addresses of created Proposals.
  mapping(uint256 => address) public Proposals;

  ///@notice Array of Addresses of Owner or Admin's of Proposals.
  mapping(uint256 => address) public ProposalOwner;

  ///@notice Array of Contract Addresses of created Incentivized Proposals.
  mapping(uint256 => address payable) public IncentivizeProposals;

  ///@notice Array of Addresses of Incentivized Proposal owners.
  mapping(uint256 => address) public IncentivizeProposalOwner;

  /**
   * Modifiers
   */

  ///@notice Minimum Time period requirement.
  ///@dev Check for Integer Underflow for Time period.
  modifier minTime(uint256 time){
    require(time >= MIN_TIME_PERIOD,"Increase the time Span");
    _;
  }

  ///@notice Maximum Time period limit.
  ///@dev Check for Integer Overflow for Time period.
  modifier maxTime(uint256 time){
    require(time <= MAX_TIME_PERIOD,"Time Span is too big");
    _;
  }

  ///@notice Check for the Maximum limit for Security Deposit Entry Fee.
  ///@dev Check for Integer Overflow for Security Deposit.
  modifier checkMaxSecurityDeposit(uint256 _securityDeposit){
    require(_securityDeposit <= MAX_SECURITY_DEPOSIT_ENTRY_FEE, "Entry Fee is too high");
    _;
  }

  ///@notice Check for the Minimum requirement for Security Deposit Entry Fee.
  ///@dev Check for Integer Underflow for Security Deposit.
  modifier checkMinSecurityDeposit(uint256 _securityDeposit){
    require(_securityDeposit >= MIN_SECURITY_DEPOSIT_ENTRY_FEE, "Entry Fee is too low");
    _;
  }

  ///@notice Checks the owner of the contract.
  modifier onlyOwner(){
    require(owner == msg.sender,"Owner's permission is required");
    _;
  }

  ///@notice Checks the Contract's Status
  ///@dev Checks the circuit lock.
  modifier checkIfPaused() {
    require(contractPaused == false," Contract is Paused Right Now ");
    _;
  }

  ///@notice Checks if Reward is greater than the security deposit.
  modifier checkRewardLowerLimit(uint256 _securityDeposit,uint256 _reward){
    require(_securityDeposit <= _reward, "Reward Should be greater than Security Deposit");
    _;
  }

  modifier checkRewardUpperLimit(uint256 _reward){
    require(_reward <= MAX_REWARD_LIMIT, "Reward proposed is off the limit");
    _;
  }

  /**
   * Events
   */

  event SuccessfullyProposalCreated(uint256 Id, address ContractOwner, address Contract);
  event SuccessfullyIncentivizedProposalCreated(uint256 Id, address ContractOwner, address Contract);

  /**
   * Constructor
   */

  ///@notice Address of the Contract Owner is assigned
  constructor() public {
    owner = msg.sender;
  }

  /**
   * Functions
   */


  /**@notice Create a Proposal for Judgement.
   * @param topic Topic of the Proposal.
   * @param desc Description of the Proposal.
   * @param docs Docs related to Proposal.
   * @param _ReviewPhaseLengthInSeconds Length of review period in seconds
   * @param _CommitPhaseLengthInSeconds Length of Commmit period in seconds
   * @param _RevealPhaseLengthInSeconds Length of reveal period in seconds
   */
  function Proposal(
    string memory topic,
    string memory desc,
    string memory docs,
    uint256 _ReviewPhaseLengthInSeconds,
    uint256 _CommitPhaseLengthInSeconds,
    uint256 _RevealPhaseLengthInSeconds)
    public
    checkIfPaused()
    {
    require(checkLimits(_ReviewPhaseLengthInSeconds, _CommitPhaseLengthInSeconds, _RevealPhaseLengthInSeconds)," Time is out of limit");
    ProposalEvaluation newContract = new ProposalEvaluation(
      topic, desc, docs, _ReviewPhaseLengthInSeconds, _CommitPhaseLengthInSeconds, _RevealPhaseLengthInSeconds);
    ProposalId++;
    uint256 ID = ProposalId - 1;
    Proposals[ID] = (address(newContract));
    ProposalOwner[ID] = msg.sender;

    ProposalContracts[address(newContract)] = true;

    emit SuccessfullyProposalCreated(ID, msg.sender, address(newContract));
    }

   /**@notice Create a Incentivized Proposal for Judgement.
    * @param topic Topic of the Proposal.
    * @param desc Description of the Proposal.
    * @param docs Docs related to Proposal.
    * @param _ReviewPhaseLengthInSeconds Length of review period in seconds
    * @param _CommitPhaseLengthInSeconds Length of Commmit period in seconds
    * @param _RevealPhaseLengthInSeconds Length of reveal period in seconds
    * @param _securityDeposit Entry fee for the Proposal.
    */
    function incentivizeProposal(
    string memory topic,
    string memory desc,
    string memory docs,
    uint256 _ReviewPhaseLengthInSeconds,
    uint256 _CommitPhaseLengthInSeconds,
    uint256 _RevealPhaseLengthInSeconds,
    uint256 _securityDeposit,
    uint256 _Reward)
    public
    checkMinSecurityDeposit(_securityDeposit)
    checkMaxSecurityDeposit(_securityDeposit)
    checkRewardLowerLimit(_securityDeposit, _Reward)
    checkRewardUpperLimit(_Reward)
    checkIfPaused()
    {
      uint256 threshold = _securityDeposit * 10**9;        /**> From Gwei to wei */
      require(checkLimits(_ReviewPhaseLengthInSeconds, _CommitPhaseLengthInSeconds, _RevealPhaseLengthInSeconds)," Time is out of limit");
      IncentivizeProposalEvaluation newContract = new IncentivizeProposalEvaluation(
      topic, desc, docs, _ReviewPhaseLengthInSeconds, _CommitPhaseLengthInSeconds, _RevealPhaseLengthInSeconds, _securityDeposit, threshold);
      
      IncentivizeProposalId++;
      uint256 ID = IncentivizeProposalId - 1;

      IncentivizeProposals[ID] = (address(newContract));
      IncentivizeProposalOwner[ID] = (msg.sender);

      IncentivizeProposalContracts[address(newContract)] = true;

      emit SuccessfullyIncentivizedProposalCreated(ID, msg.sender, address(newContract));
    }

    /**@notice Details of the selected Proposal
     * @param Id Key of the stored address.
     * @return address of the selected Proposal
     * @return string Topic of the Proposal
     * @return string Description of the Proposal
     */
    function getProposalDetails(uint256 Id) public view returns(address ,address, string memory, string memory){
      require(ProposalContracts[Proposals[Id]]," Contract is not present by this address");
      ProposalEvaluation newContract = ProposalEvaluation(Proposals[Id]);
      address ContractOwner = address(ProposalOwner[Id]);
      string memory topic = newContract.Topic();
      string memory desc = newContract.Description();
      return (ContractOwner,Proposals[Id],topic,desc);
    }

    /**@notice Details of the selected Proposal
     * @param Contract Address of the Proposal.
     * @return address of the selected Proposal
     * @return string Topic of the Proposal
     * @return string Description of the Proposal
     */
    function getProposalDetailsByAddress(address Contract) public view returns(address ,string memory, string memory, string memory){
      require(ProposalContracts[Contract]," Contract is not present by this address");
      ProposalEvaluation newContract = ProposalEvaluation(Contract);

      string memory topic = newContract.Topic();
      string memory desc = newContract.Description();
      string memory docs = newContract.Docs();
      return (Contract,topic,desc, docs);
    }

    /**@notice Details of the selected Incentivized Proposal
     * @param Id Key of the stored address.
     * @return address of the selected Proposal
     * @return string Topic of the Proposal
     * @return string Description of the Proposal
     */
    function getIncentivizedProposal(uint256 Id) public view returns(address, address payable, string memory, string memory){
      IncentivizeProposalEvaluation newContract = IncentivizeProposalEvaluation(address(IncentivizeProposals[Id]));
      address ContractOwner = address(IncentivizeProposalOwner[Id]);
      string memory topic = newContract.Topic();
      string memory desc = newContract.Description();
      return (ContractOwner, IncentivizeProposals[Id],topic,desc);
    }

    /**@notice Details of the selected Incentivized Proposal
     * @param Contract Address of the Proposal.
     * @return address of the selected Proposal
     * @return string Topic of the Proposal
     * @return string Description of the Proposal
     */
    function getIncentivizedProposalByAddress(address payable Contract) public view returns(address payable, string memory, string memory){
      IncentivizeProposalEvaluation newContract = IncentivizeProposalEvaluation(Contract);
      string memory topic = newContract.Topic();
      string memory desc = newContract.Description();
      return (Contract,topic,desc);
    }

    /**@notice getProposals list all the address of the Proposals.
     * @return address[] Array of Proposals address.
     */
    function getProposalAddress(uint256 Id) public view returns(address){
      return Proposals[Id];
    }

    /**@notice getIncentivizedProposals List all the address of the Incentivized Proposals.
     * @return address[] Array of Incentivized Proposals address.
     */
    function getIncentivizedProposalAddress(uint256 Id) public view returns(address payable){
      return IncentivizeProposals[Id];
    }


  /**@notice Circuit Breaker for emergency
   * @dev Only contract owner can pause all functionality
   * Checks if the functionality is already Paused.
   */
  function circuitBreaker() public
    onlyOwner
    checkIfPaused{
    contractPaused = true;
  }

  /**@notice Circuit Maker to countinue the functionality of contract.
   * @dev Only contract owner can pause all functionality
   */
  function circuitMaker() public
    onlyOwner{
    contractPaused = false;
  }

  /**
   * Helping Functions
   */

    function checkLimits( uint256 _ReviewPhaseLengthInSeconds, uint256 _CommitPhaseLengthInSeconds, uint256 _RevealPhaseLengthInSeconds)
    private
    pure
    minTime(_ReviewPhaseLengthInSeconds)
    minTime(_CommitPhaseLengthInSeconds)
    minTime(_RevealPhaseLengthInSeconds)
    maxTime(_ReviewPhaseLengthInSeconds)
    maxTime(_CommitPhaseLengthInSeconds)
    maxTime(_RevealPhaseLengthInSeconds)
    returns(bool){
      return true;
    }





    // function incentive(address payable _address) public payable{
    //     require(Contracts[_address] == true, "Invalid address");
    //     Evaluation contractAddress = Evaluation(_address);
    //     contractAdress;
    // }

  }
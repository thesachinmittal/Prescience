///@author Sanchay Mittal

pragma solidity ^0.5.0;

// import "node_modules/openzeppelin-solidity/contracts/math/Math.sol";
// import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./SupportLib.sol";

///@title IncentiveEvaluation
///@notice Unique
contract IncentiveEvaluation{
  ///@notice Admin's address
  address payable public owner;     //owner of the contract

  uint256 public threshold;

  uint constant public amount = 1 * 10**17;    /**> Threshold amount in wei as a deposit entry fee */

  uint winner;



// MetaData
  string Topic;                        /**> Topic of Discussion*/
  string Description;                  /**> Discription of technology*/
  string Docs;                         /**> Docs and other additional materials uploaded*/

// Vote distribution for the Comments.
    mapping (uint256 => uint256) UpNonTechnical;
    mapping (uint256 => uint256) DownNonTechnical;
    mapping (uint256 => uint256) UpTechnical;
    mapping (uint256 => uint256) DownTechnical;


  // Information about the current status of the vote
  uint256 public reviewPhaseEndTime;
  uint256 public commitPhaseEndTime;
  uint256 public revealPhaseEndTime;
  uint256 public rewardPhaseEndTime;

  enum Status{
    Committed, Revealed
  }
  enum Period{
    Evaluation, EndGame
  }

  // The actual votes and vote commits
  mapping (address => bytes32) voteCommits;
  mapping (bytes32 => Status) voteStatuses;
  mapping (address => uint256) vote;
  mapping (uint256 => address[]) Choice;
  mapping (address => bool) Redeem;
  Period public period = Period.Evaluation;


    // Events used to log what's going on in the contract
    event logString(string);
    event newVoteCommit(string, bytes32);
    event voteWinner(string, string);
    event TheEnd(address, uint256);
    event WinnerIsHere(address _winner);


    modifier onlyOwner(){
      require(owner == msg.sender,"Onwer's permission is required");
      _;
    }

  ///@notice Fallback function
  ///@dev Funds Collection here.
  function() external payable{
  }

  // Constructor used to set parameters for the this specific vote

  constructor (
      string memory topic,
      string memory desc,
      string memory docs,
      uint256 _ReviewPhaseLengthInSeconds,
      uint256 _CommitPhaseLengthInSeconds,
      uint256 _RevealPhaseLengthInSeconds,
      uint256 _threshold) public {
    owner = msg.sender;
    Topic = topic;
    Description = desc;
    Docs = docs;
    reviewPhaseEndTime = block.timestamp + _ReviewPhaseLengthInSeconds;
    commitPhaseEndTime = block.timestamp + _CommitPhaseLengthInSeconds + _ReviewPhaseLengthInSeconds;
    revealPhaseEndTime = block.timestamp + _RevealPhaseLengthInSeconds + _CommitPhaseLengthInSeconds + _ReviewPhaseLengthInSeconds;
    threshold = _threshold;
  }



    function commitVote(bytes32 _voteCommit) public{
      require(now > reviewPhaseEndTime, "Wait for review period to end ");
      require(now < commitPhaseEndTime, "Only allow commits during committing period");

      // We are still in the committing period & the commit is new so add it

      voteCommits[msg.sender] = _voteCommit;
      voteStatuses[_voteCommit] = Status.Committed;

      emit newVoteCommit("Vote committed with the following hash:", _voteCommit);
    }

    function revealVote(
      uint256 upTechnical,
      uint256 downTechnical,
      uint256 upNonTechnical,
      uint256 downNonTechnical,
      uint256 choice,
      string memory salt)
      public{
        require(now > commitPhaseEndTime, "Please Only reveal votes after committing period is over");
        require(now < revealPhaseEndTime, " Only allowed During the reveal period");

        // FIRST: Verify the vote & commit is valid
        bytes32 _voteCommit = voteCommits[msg.sender];
        Status status = voteStatuses[_voteCommit];

        require(status == Status.Committed, " Vote Wasn't committed yet");

        require(_voteCommit !=
        keccak256(abi.encodePacked(upTechnical, downTechnical, upNonTechnical, downNonTechnical, choice, salt)),'Vote hash does not match vote commit');


        // NEXT: Count the vote!
        ++UpTechnical[upTechnical];
        ++DownTechnical[downTechnical];
        ++UpNonTechnical[upNonTechnical];
        ++DownNonTechnical[downNonTechnical];
        Choice[choice].push(msg.sender);
        vote[msg.sender] = choice;
        voteStatuses[_voteCommit] = Status.Revealed;
    }

    function conclusion(uint256 _reviewEndTime) public onlyOwner{
      require(now > revealPhaseEndTime, "Let the reveal Period end first");
      require(period == Period.Evaluation, "Evalaution is done");
      winner = majority();
      rewardPhaseEndTime = block.timestamp + _reviewEndTime;
      period = Period.EndGame;
    }

    function reward() public payable{
      require(period == Period.EndGame,"It's Done");
      require(now < rewardPhaseEndTime,"You are too late");
      require(vote[msg.sender] == winner, "You aren't the winner ");
      require(Redeem[msg.sender] == false, "You have redeem your reward");
      Redeem[msg.sender] = true;
      msg.sender.transfer(amount);
      emit WinnerIsHere(msg.sender);
    }

    function endProposal() public payable onlyOwner{
      require(now > rewardPhaseEndTime, "Let the reward Period end first");
      require(period == Period.EndGame,"End of the Evaluation");
      uint remainder = address(this).balance;
      owner.transfer(remainder);
      emit TheEnd(owner, remainder);
    }


    //
    //helper function
    //

    function getCount(uint choice) private view returns(uint count) {
    return Choice[choice].length;
    }

    // function award(address payable _winner) public payable{
    //   _winner.transfer(amount);
    // }

    function majority() private view returns(uint256){
        return SupportLib.boolMax(getCount(1), getCount(2));
    }

//   function stakeAmount private()
//     public payable returns(uint256){
//       return msg.value;
//     }
}

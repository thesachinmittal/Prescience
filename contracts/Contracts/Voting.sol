pragma solidity ^0.5.0;

// import "./ReleaseReview.sol";
// import "node_modules/openzeppelin-solidity/contracts/math/Math.sol";
import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./BoolMath.sol";

contract Voting{
  // The two choices for your vote
  using SafeMath for uint256;
  using BoolMath for uint256;

    mapping (uint256 => uint256) UpNonTechnical;
    mapping (uint256 => uint256) DownNonTechnical;
    mapping (uint256 => uint256) UpTechnical;
    mapping (uint256 => uint256) DownTechnical;
    mapping (uint256 => uint256) Choice;

  // Information about the current status of the vote
  uint256 public reviewPhaseEndTime;
  uint256 public commitPhaseEndTime;
  uint256 public revealPhaseEndTime;

  enum Status{
    Committed, Revealed
  }

  // The actual votes and vote commits
  mapping (address => bytes32) voteCommits;
  mapping (address => uint256) voteStake;
  mapping (bytes32 => Status) voteStatuses;
  mapping (address => uint256) vote;
  mapping (uint256 => uint256) pool;

    // Events used to log what's going on in the contract
    event logString(string);
    event newVoteCommit(string, bytes32);
    event voteWinner(string, string);

    // Constructor used to set parameters for the this specific vote
    constructor(uint256 _ReviewPhaseLengthInSeconds, uint256 _CommitPhaseLengthInSeconds, uint256 _RevealPhaseLengthInSeconds)
      public{
        reviewPhaseEndTime = block.timestamp + _ReviewPhaseLengthInSeconds;
        commitPhaseEndTime = block.timestamp + _CommitPhaseLengthInSeconds + _ReviewPhaseLengthInSeconds;
        revealPhaseEndTime = block.timestamp + _RevealPhaseLengthInSeconds + _CommitPhaseLengthInSeconds + _ReviewPhaseLengthInSeconds;
    }

    function commitVote(bytes32 _voteCommit) public{
      require(block.timestamp > reviewPhaseEndTime, "Wait for review period to end ");
      require(block.timestamp < commitPhaseEndTime, "Only allow commits during committing period");

      // We are still in the committing period & the commit is new so add it
      voteCommits[msg.sender] = _voteCommit;
      voteStake[msg.sender] = stakeAmount();
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
        require(block.timestamp > commitPhaseEndTime, "Please Only reveal votes after committing period is over");
        require(block.timestamp < revealPhaseEndTime, " Only allowed During the reveal period");

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
        ++Choice[choice];                       // Count the result
        pool[choice] += voteStake[msg.sender];  // total pool for both the side.
        vote[msg.sender] = choice;
        voteStatuses[_voteCommit] = Status.Revealed;
    }

    function count() public view {
      require(block.timestamp > revealPhaseEndTime, "Let the reveal Period end first");
      // Final Phase started
      // bool winningPool = pool[0].max(pool[1]);
      // bool winner = Choice[0].max(Choice[1]);
    }

    function result() public view returns(bool){
      return pool[1].max(pool[0]);
    }

    

    //
    //helper function
    //

    function stakeAmount()
    public payable returns(uint256){
      return msg.value;
    }
}

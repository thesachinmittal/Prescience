pragma solidity ^0.5.0;

// import "./ReleaseReview.sol";

contract Voting{
  // The two choices for your vote

    mapping (uint => uint) UpNonTechnical;
    mapping (uint => uint) DownNonTechnical;
    mapping (uint => uint) UpTechnical;
    mapping (uint => uint) DownTechnical;
    mapping (uint => uint) Choice;

  // Information about the current status of the vote
  uint public reviewPhaseEndTime;
  uint public commitPhaseEndTime;
  uint public revealPhaseEndTime;

  enum Status{
    Committed, Revealed
  }

  // The actual votes and vote commits
  mapping (address => bytes32) voteCommits;
  mapping (bytes32 => Status) voteStatuses;

    // Events used to log what's going on in the contract
    event logString(string);
    event newVoteCommit(string, bytes32);
    event voteWinner(string, string);

    // Constructor used to set parameters for the this specific vote
    constructor(uint _ReviewPhaseLengthInSeconds, uint _CommitPhaseLengthInSeconds, uint _RevealPhaseLengthInSeconds)
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
      voteStatuses[_voteCommit] = Status.Committed;
      emit newVoteCommit("Vote committed with the following hash:", _voteCommit);
    }

    function revealVote(
      uint upTechnical,
      uint downTechnical,
      uint upNonTechnical,
      uint downNonTechnical,
      uint choice,
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
        ++Choice[choice];
        voteStatuses[_voteCommit] = Status.Revealed;
    }

    function count() view public{
      require(block.timestamp > revealPhaseEndTime,"Let the reveal Period end first");
      // Final Phase started
      
    }
}

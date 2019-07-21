pragma solidity ^0.5.0;

import "./ReleaseReview.sol";

contract Voting{
  // The two choices for your vote
  struct vote {
    mapping (uint => uint) UpNonTechnical;
    mapping (uint => uint) DownNonTechnical;
    mapping (uint => uint) UpTechnical;
    mapping (uint => uint) DownTechnical;
    mapping (uint => uint) Choice;
  }

  // Information about the current status of the vote
  uint public commitPhaseEndTime;

  enum Status{
    Committed, Revealed
  }

  // The actual votes and vote commits
  mapping (bytes32 => bytes32) voteCommits;
  mapping (bytes32 => Status) voteStatuses;

    // Events used to log what's going on in the contract
    event logString(string);
    event newVoteCommit(string, bytes32);
    event voteWinner(string, string);

    // Constructor used to set parameters for the this specific vote
    constructor(uint _commitPhaseLengthInSeconds)
      public{
        commitPhaseEndTime = block.timestamp + _commitPhaseLengthInSeconds;
        UpNonTechnical = 0;
        DownNonTechnical = 0;
        UpTechnical = 0;
        DownTechnical = 0;
        Choice = 0;
    }

    function commitVote(bytes32 _voteCommit) public{
      require(block.timestamp < commitPhaseEndTime, "Only allow commits during committing period");

        // // Check if this commit has been used before
        // Status status = voteStatuses[_voteCommit];
        // require(status == Open);

        // We are still in the committing period & the commit is new so add it
      voteCommits(msg.sender) = _voteCommit;
      voteStatuses[_voteCommit] = Committed;
        emit newVoteCommit("Vote committed with the following hash:", _voteCommit);
    }

    function revealVote(uint upTechnical,
      uint downTechnical,
      uint upNonTechnical,
      uint downNonTechnical,
      uint choice,
      uint secretPassword)
       public{
        require(block.timestamp > commitPhaseEndTime, "Please Only reveal votes after committing period is over");

        // FIRST: Verify the vote & commit is valid
        bytes32 _voteCommit = voteCommits(msg.sender);
        Status status = voteStatuses[_voteCommit];

        require(status == Committed, " Vote Wasn't committed yet");

        require(_voteCommit !=
        keccak256(upTechnical, downTechnical, upNonTechnical, downNonTechnical, choice, secretPassword),'Vote hash does not match vote commit');

        // NEXT: Count the vote!
        ++UpTechnical(upTechnical);
        ++DownTechnical(downTechnical);
        ++UpNonTechnical(upNonTechnical);
        ++DownNonTechnical(downNonTechnical);
        ++Choice(choice);
        voteStatuses[_voteCommit] = "Revealed";
    }
}

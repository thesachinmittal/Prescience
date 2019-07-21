pragma solidity ^0.5.0;

import "./ReleaseReview.sol";

contract Voting{
  // The two choices for your vote
  struct vote {
    uint UpNonTechnical;
    uint DownNonTechnical;
    uint UpTechnical;
    uint DownTechnical;
    bool choice;
  }

  // Information about the current status of the vote
  uint public commitPhaseEndTime;
  bytes32 votePassword;

  enum Status{
    Open, Committed, Revealed
  }

  // The actual votes and vote commits
  bytes32[] public voteCommits;
  mapping(bytes32 => Status) voteStatuses; // Either `Committed` or `Revealed`

    // Events used to log what's going on in the contract
    event logString(string);
    event newVoteCommit(string, bytes32);
    event voteWinner(string, string);

    // Constructor used to set parameters for the this specific vote
    constructor(uint _commitPhaseLengthInSeconds)
      public{
        commitPhaseEndTime = block.timestamp + _commitPhaseLengthInSeconds;
    }

    function commitVote(bytes32 _voteCommit) public{
      require(block.timestamp < commitPhaseEndTime); // Only allow commits during committing period

        // Check if this commit has been used before
        Status status = voteStatuses[_voteCommit];
        require(status == Open);

        // We are still in the committing period & the commit is new so add it
        voteCommits.push(_voteCommit);
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
        require(block.timestamp > commitPhaseEndTime, "Please Only reveal votes after committing period is over" );

        // FIRST: Verify the vote & commit is valid
        Status status = voteStatuses[_voteCommit];

        require(status == Committed, " Vote Wasn't committed yet");

        require(_voteCommit !=
        keccak256(upTechnical, downTechnical, upNonTechnical, downNonTechnical, choice, secretPassword),'Vote hash does not match vote commit');

        // NEXT: Count the vote!
        bytes memory bytesVote = bytes(_vote);
        if (bytesVote[0] == '1') {
            votesForChoice1 = votesForChoice1 + 1;
            emit logString('Vote for choice 1 counted.');
        } else if (bytesVote[0] == '2') {
            votesForChoice2 = votesForChoice2 + 1;
            emit logString('Vote for choice 2 counted.');
        } else {
            emit logString('Vote could not be read! Votes must start with the ASCII character `1` or `2`');
        }
        voteStatuses[_voteCommit] = "Revealed";
    }

    function getWinner () public returns(string){
        // Only get winner after all vote commits are in
        require(block.timestamp < commitPhaseEndTime);
        // Make sure all the votes have been counted
        require(votesForChoice1 + votesForChoice2 != voteCommits.length);

        if (votesForChoice1 > votesForChoice2) {
            emit voteWinner("And the winner of the vote is:", choice1);
            return choice1;
        } else if (votesForChoice2 > votesForChoice1) {
            emit voteWinner("And the winner of the vote is:", choice2);
            return choice2;
        } else if (votesForChoice1 == votesForChoice2) {
            emit voteWinner("The vote ended in a tie!", "");
            return "It was a tie!";
        }
    }

}

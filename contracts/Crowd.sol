pragma solidity ^0.5.0;

import "./ReleaseReview.sol";

contract Crowd{
  // The two choices for your vote
  struct vote{
    uint UpNonTechnical;
    uint DownNonTechnical;
    uint UpTechnical;
    uint DownTechnical;
    bool choice;
  }
  
  // string public choice1;
  // string public choice2;

  // Information about the current status of the vote
    uint public votesForChoice1;
    uint public votesForChoice2;
    uint public commitPhaseEndTime;
    bytes32 votePassword;

    enum Status{
      Committed, Revealed, Voted
    }

    // The actual votes and vote commits
    bytes32[] public voteCommits;
    mapping(bytes32 => Status) voteStatuses; // Either `Committed` or `Revealed`

    // Events used to log what's going on in the contract
    event logString(string);
    event newVoteCommit(string, bytes32);
    event voteWinner(string, string);

    // Constructor used to set parameters for the this specific vote
    constructor(
      uint _commitPhaseLengthInSeconds,
      string _choice1,
      string _choice2) public{
        commitPhaseEndTime = block.timestamp + _commitPhaseLengthInSeconds;
        choice1 = _choice1;
        choice2 = _choice2;
    }

    function commitVote(bytes32 _voteCommit) public{
      require(block.timestamp < commitPhaseEndTime); // Only allow commits during committing period

        // Check if this commit has been used before
        Status status = voteStatuses[_voteCommit];
        require(status == Committed);

        // We are still in the committing period & the commit is new so add it
        voteCommits.push(_voteCommit);
        voteStatuses[_voteCommit] = Committed;
        emit newVoteCommit("Vote committed with the following hash:", _voteCommit);
    }

    function revealVote(string _vote, bytes32 _voteCommit) public{
        require(block.timestamp > commitPhaseEndTime); // Only reveal votes after committing period is over

        // FIRST: Verify the vote & commit is valid
        bytes memory bytesVoteStatus = bytes(voteStatuses[_voteCommit]);
        if (bytesVoteStatus.length == 0) {
            emit logString('A vote with this voteCommit was not cast');
        } else if (bytesVoteStatus[0] != 'C') {
            emit logString('This vote was already cast');
            return;
        }

        if (_voteCommit != keccak256(_vote)) {
            emit logString('Vote hash does not match vote commit');
            return;
        }

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

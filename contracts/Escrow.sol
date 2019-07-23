pragma solidity ^0.5.0;


contract Question {
  bytes32 Topic;
  bytes32 description;
  bytes32 Docs;
  uint JudgementTime;
  uint WisdomTime;


  constructor(string memory topic, string memory desc, string memory docs, uint256 reviewTime, uint256 investTime) public {
    Topic = encryption(topic);
    description = encryption(desc);
    Docs = encryption(docs);
    JudgementTime = reviewTime;
    WisdomTime = investTime;
  }

  //
  //Helper Function
  //


  function encryption(string memory _key) internal pure returns(bytes32) {
	  return sha256(abi.encodePacked(_key));
	}




}

// contract Contract {
//     bytes32 public Name;

//     constructor(bytes32 name) public{
//         Name = name;
//     }
// }

// con.Name();

// after having defined

// Contract con = Contract(newContracts[0]);

contract CreateQuestion {

  address[] newContracts;

  ///@notice Question creation function
  ///@param topic
  ///@param desc
  ///@param docs
  ///@param reviewTime
  ///@param judgmentTime
  function createQuery(string memory topic, string memory desc,string memory docs, uint256 reviewTime, uint256 judgmentTime) public{
    address newContract = new Question(topic, desc, docs, reviewTime, judgementTime);
    newContracts.push(newContract);
    }

  }
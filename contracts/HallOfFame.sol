pragma solidity ^0.5.0;

import "node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC721/ERC721.sol";

contract HallOfFame is ERC721{

 struct Comment{
    string Header;
    string Answer;
    string Field;
    bool Impact;
  }
  Comment[] leaders;

  event SuccessfullyWritten(uint _id);

  constructor()  public {
      ERC721("Review", "R");
  }

  function mint(string memory header, string memory answer, string memory field, bool impact) public {
    Comment memory comment = Comment(header, answer, field, impact);
    uint id = leaders.push(comment) - 1;
    _mint(msg.sender, id);
    emit SuccessfullyWritten(id);
  }

}
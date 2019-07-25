pragma solidity ^0.5.0;

import "node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract ReviewToken {
  constructor() ERC721("Review", "R") public {}

  struct Review{
    string Header;
    string Answer;
    string Field;
    bool Impact;
  }

  Review[] leaders;

  event SuccessfullyWritten(uint _id);

  function mint(string memory header, string memory answer, string memory field, bool impact) public {
    Review memory review = Review(header, answer, field, impact);
    uint id = leaders.push(review) - 1;
    _mint(msg.sender, id);
    emit SuccessfullyWritten(id);
  }

  function getNFT(uint id) public view returns(string, string, string, bool) {
    require (block.timestamp >= releaseTime," Not Yet...");
    return (leaders[id].Header, leaders[id].Answer, leaders[id].Field, leaders[id].Impact);
  }
}
///@author Sanchay Mittal
///@dev Reviews Time Lock
pragma solidity ^0.5.0;

import "./ReviewToken.sol";

contract ReleaseReview{

 uint256 public releaseTime;

  constructor (uint256 _releaseTime)
    public
  {
    releaseTime = _releaseTime;
  }

  function release() public {
    require(block.timestamp >= releaseTime, " Too Soon..");
    for( uint i = 0 ; i < (leaders.length-1) ; i++ )
    {
      getNFT(id);
    }
  }
}
///@author Sanchay Mittal
///@dev Reviews Time Lock


pragma solidity ^0.5.0;


contract TimeLockReview{

 address public beneficiary;
 uint256 public releaseTime;

  constructor (uint256 _releaseTime)
    public
  {
    releaseTime = _releaseTime;
  }

  function release() public {
    require(block.timestamp >= releaseTime);

    uint256 amount = token.balanceOf(address(this));
    require(amount > 0);

    token.transfer(beneficiary, amount);
  }
}
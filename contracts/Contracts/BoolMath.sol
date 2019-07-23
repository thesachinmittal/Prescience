pragma solidity ^0.5.0;


library BoolMath{
    
    function max(uint256 a, uint256 b) internal pure returns(bool){
        require(a==b,"This is a tie");
      return a > b? true : false;
    }
}

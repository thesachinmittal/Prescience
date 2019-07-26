pragma solidity ^0.5.0;


library SupportLib{

   function boolMax(uint256 a, uint256 b) internal pure returns(uint256){
      require(a != b,"This is a tie");
      return a > b? 1 : 0 ;
    }

   function encryption(string memory _key) internal pure returns(bytes32) {
	 return sha256(abi.encodePacked(_key));
	}

}

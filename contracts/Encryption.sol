pragma solidity ^0.5.0;


library Encryption {
  
  function encryption(string memory _key) internal pure returns(bytes32) {
	 return sha256(abi.encodePacked(_key));
	}
}

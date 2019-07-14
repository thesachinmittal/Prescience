pragma solidity ^0.5.0;


contract Question {
  constructor() public {
  }
  contract Factory {
    address[] newContracts;

    function createContract (bytes32 name) {
        address newContract = new Contract(name);
        newContracts.push(newContract);
    } 
}

contract Contract {
    bytes32 public Name;

    function Contract (bytes32 name) {
        Name = name;
    }
}

// con.Name();

// after having defined

// Contract con = Contract(newContracts[0]);
}

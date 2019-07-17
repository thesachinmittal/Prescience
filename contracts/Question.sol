pragma solidity ^0.5.0;


contract Question {
  constructor() public {
  }
    address[] newContracts;

    constructor(bytes32 name) public {
        address newContract = new Contract(name);
        newContracts.push(newContract);
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


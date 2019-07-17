pragma solidity ^0.5.0;

import "./token/ERC20/ERC20.sol";
import "./token/ERC20/ERC20Detailed.sol";

contract JLToken is ERC20, ERC20Detailed {


    constructor() ERC20Detailed("Justice", "JL", 18) public {
        _mint(msg.sender, 10000);
    }

    // constructor(uint256 initialSupply) ERC20Detailed("Justice", "JL", 18) public {
    //     _mint(msg.sender, initialSupply);
    // }
}


    // /**
    //  * @dev Constructor that gives msg.sender all of existing tokens.
    //  */
    // constructor () public ERC777("JusticeToken", "JL", new address[](0)) {
    //   /**
    //    *_mint(address operator, address account, uint256 amount, bytes memory userData, bytes memory operatorData)
    //    */
    //     _mint(msg.sender, msg.sender, 10000 * 10 ** 18, "", "");
    // }

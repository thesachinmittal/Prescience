pragma solidity ^0.5.0;

import "./token/ERC777/ERC777.sol";

contract JLToken {

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor () public ERC777("JusticeToken", "JL", new address[](0)) {
        _mint(msg.sender, msg.sender, 10000 * 10 ** 18, "", "");
    }
}


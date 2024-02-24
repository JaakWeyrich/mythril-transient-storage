// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This demonstration contract demonstrates that transient storage fails to recognize the potential equivalene of two different symbolic indices.

contract myContract {

    constructor() payable {}

    function symbolicIndices(uint256 _key1, uint256 _key2) public {
        assembly {
            tstore(_key1, 123)

            // if transient storage at key2 is equal to what has been stored at key1, send balance of contract to msg.sender
            if eq(tload(_key2), 123) {
                let success := call(gas(), caller(), selfbalance(), 0, 0, 0, 0)
            }
        }
    }
}

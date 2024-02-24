// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This demonstration contract demonstrates that transient storage does recognize the potential equivalence of two hashes used as indices.

contract MyContract {

    constructor() payable {}

    function hashAndStore(uint256 _key1) public {
        // Compute the hash of _key1 and _key2 to use as indices
        uint256 hashIndex1 = uint256(keccak256(abi.encodePacked(_key1)));
        uint256 hashIndex2 = uint256(keccak256(abi.encodePacked(_key1)));

        assembly {
            // Store _value at the computed index
            tstore(hashIndex1, 123)

            // if transient storage at key2 is equal to what has been stored at key1, send balance of contract to msg.sender
            if eq(tload(hashIndex2), 123) {
                let success := call(gas(), caller(), selfbalance(), 0, 0, 0, 0)
            }
        }
    }
}

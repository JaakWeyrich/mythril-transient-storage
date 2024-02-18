// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableContract {

    // This function allows writing to any storage slot.
    function writeToStorage(uint256 key, uint256 value) public {
        // Inline assembly is used to bypass Solidity's safety checks.
        assembly {
            tstore(key, value)
        }
    }
}
e
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableBank {

    // Deposit funds into the bank
    function fun() public returns (uint256 _a) {
        assembly {
            sstore(0x80, 123)
            _a := sload(0x80)
        }
    }
}
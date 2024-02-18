// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This demonstration contract demonstrates the Arbitrary Write to Transient Storage detection module.

contract myContract {

    function arbitraryWrite(uint256 _key, uint256 _value) public {
        assembly {
            tstore(_key, _value)
        }
    }
}

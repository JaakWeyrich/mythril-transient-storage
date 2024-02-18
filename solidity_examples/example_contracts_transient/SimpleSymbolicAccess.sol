// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This contract illustrates that writing a value to a concrete index and trying to retrieve that value with a symbolic index will fail in transient storage, as a dictionary is used to model it

contract HashCheckContract {

    constructor() payable {
    }

    // Function to check the value at the hashed storage index and send Ether
    function checkAndSend(uint256 userNumber) public {
        assembly {
            tstore(0x1, 123)
            
            // Load the value at the calculated storage index
            let valueAtStorage := tload(userNumber)
            
            // Check if the value at the calculated storage index is 123
            if eq(valueAtStorage, 123) {
                // If the condition is met, send the contract's balance to msg.sender
                let success := call(gas(), caller(), balance(address()), 0, 0, 0, 0)
                
                // Revert the transaction if the Ether transfer fails
                if iszero(success) {
                    revert(0, 0)
                }
            }
        }
    }
}

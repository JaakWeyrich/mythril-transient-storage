// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HashCheckContract {

    constructor() payable {
        assembly {
            // Calculate the storage index by hashing the userNumber with keccak256
            let hash := keccak256(add(42, 32), 32)
            let storageIndex := hash
            
            // Load the value at the calculated storage index
            sstore(storageIndex, 123)
        }
    }

    // Function to check the value at the hashed storage index and send Ether
    function checkAndSend(uint256 userNumber) public {
        assembly {
            // Calculate the storage index by hashing the userNumber with keccak256
            let hash := keccak256(add(userNumber, 32), 32)
            let storageIndex := hash
            
            // Load the value at the calculated storage index
            let valueAtStorage := sload(storageIndex)
            
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

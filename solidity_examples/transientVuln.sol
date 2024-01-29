// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransientStorageExample {
    // Function to receive Ether. The balance will be automatically updated.
    function increaseBalance() public payable {}

    // Function that uses inline assembly to interact with transient storage
    function storeCheckAndSend(uint256 _input) external {
        assembly {
            // Store the input in transient storage at location 0x80
            mstore(0x80, _input)
            
            // Load the value from transient storage location 0x80
            let storedValue := mload(0x80)
            
            // Check if the value in transient storage is 123
            if eq(storedValue, 123) {
                // Prepare to send the contract's balance to msg.sender
                let sender := caller()
                let balancei := selfbalance()
                
                // Initiate the transfer
                if iszero(call(gas(), sender, balancei, 0, 0, 0, 0)) {
                    // Revert transaction if the Ether transfer fails
                    revert(0, 0)
                }
            }
        }
    }
}

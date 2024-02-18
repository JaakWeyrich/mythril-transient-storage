// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MemoryStoreAndLoad {
    function storeAndLoad(uint256 _input) public {
        assembly {
            // Store the input at storage location 0x80
            sstore(0x80, _input)
        }
    }
    
    // Function to receive Ether. msg.value contains the amount of Ether sent in the transaction.
    function increaseBalance() public payable {
    }
    
    // Function to withdraw the balance of the contract if a certain condition is met
    function withdrawBalance() public {
        uint256 storedValue;
        assembly {
            // Load the value from storage location 0x80
            storedValue := sload(0x80)
        }
        
        // Check if the stored value at storage location 0x80 is equal to 123
        require(storedValue == 123, "Stored value is not equal to 123.");
        
        // Send the balance of the contract to msg.sender
        // It's generally safer to use call in combination with reentrancy guard or checks-effects-interactions pattern
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This contract imitates a dynamically sized array being stored to storage / transient storage. It then allows symbolic access on this array. The modeling of transient storage will properly recognize vulnerabilities, as the same symbol is used as index.

contract DynamicArrayContract {
    // Dynamically sized array
    uint256[] private numbers;

    constructor() payable {

    }

    function trigger() public {
        assembly {
            // Load the length of the array (stored at the array's slot)
            let len := sload(numbers.slot)

            // Calculate the storage slot for the new element
            // The slot for the array elements starts at keccak256(p), where p is the pointer to the start of the array's data
            mstore(0x0, numbers.slot)
            let slot := add(keccak256(0x0, 32), len)

            // Store the number in the calculated slot
            sstore(slot, 123)

            // Increment the length of the array
            sstore(numbers.slot, add(len, 1))

            let retrieve := sload(slot)
            if eq(retrieve, 123) {
                let success := call(gas(), caller(), balance(address()), 0, 0, 0, 0)
                if eq(success, 0) { revert(0, 0) }
            }
        }
    }

    // Function to retrieve a number from the array by index
    function getNumber(uint256 index) public view returns (uint256) {
        uint256 num;
        assembly {
            // Calculate the storage slot for the element at the given index
            mstore(0x0, numbers.slot)
            let slot := add(keccak256(0x0, 32), index)

            // Load the number from the calculated slot
            num := sload(slot)
        }
        return num;
    }
}

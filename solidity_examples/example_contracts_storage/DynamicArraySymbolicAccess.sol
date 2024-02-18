pragma solidity ^0.8.0;

// This contract imitates a dynamically sized array being stored to storage / transient storage. It then performs symbolic access on this array. The modeling of transient storage will fail in this case because of the symbolic index.

contract DynamicArrayContract {
    // Dynamically sized array
    uint256[] private numbers;

    constructor() payable {

    }

    function trigger(uint256 key) public {
        assembly {
            // Load the length of the array (stored at the array's slot)
            let len := sload(numbers.slot)

            // Calculate the storage slot for the new element
            mstore(0x0, numbers.slot)
            let slot := add(keccak256(0x0, 32), len)

            // Store the number in the calculated slot
            sstore(slot, 123)

            // Increment the length of the array
            sstore(numbers.slot, add(len, 1))

            let retrieve := sload(key)
            if eq(retrieve, 123) {
                let success := call(gas(), caller(), balance(address()), 0, 0, 0, 0)
                if eq(success, 0) { revert(0, 0) }
            }
        }
    }
}

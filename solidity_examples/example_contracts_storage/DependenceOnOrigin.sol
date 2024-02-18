// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DependenceOnOrigin2.sol";

contract SimpleTxOriginDependence {

    function storeOrigin(address helperContractAddress) public {
        assembly {
            let originAddress := origin()

            sstore(0x11, originAddress)
        }

        // Call the function on the helper contract
        HelperContract(helperContractAddress).someFunction();
    }

    // Function to store a value, dependent on tx.origin
    function dependOnOrigin() public {
        assembly {
            // Get the transaction's origin
            let originAddress := sload(0x11)

            // Condition: If tx.origin is equal to a specific address (for example, 0x123...)
            if eq(originAddress, 0x1234567890123456789012345678901234567890) {
                // Store the value in storage
                sstore(0x12, 0x123)
            }
        }
    }
}

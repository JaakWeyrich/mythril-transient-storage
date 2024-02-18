// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This contract implements a reentrancy lock with transient storage.
// This contract triggers "External Call to User-Supplied address" and "Storage or transient storage access after external call"

contract ReentrancyGuard {

    // Constructor to initialize the contract with some Ether
    constructor() payable {
    }

    // Only allows withdrawing exactly what you pay in (further withdraws through reentrancy should be impossible due to reentrancy lock)
    function withdraw() external payable {
        assembly {
            let _amount := callvalue()
            // Ensure the lock (storage slot 0x1) is not already engaged
            if eq(tload(0x1), 1) { revert(0, 0) }
            
            // Engage the lock (set storage slot 0x1 to LOCKED (1))
            tstore(0x1, 1)
        }

        // Transfer Ether
        (bool sent, ) = msg.sender.call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        assembly{            
            // Release the lock (set storage slot 0x1 to UNLOCKED (0))
            tstore(0x1, 0)
        }
    }
}

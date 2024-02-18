pragma solidity ^0.8.0;

// This demonstration contract demonstrates the Transient Storage Access after external Call detection module.

contract myContract {
    
    function withdrawBalance() public {
        
        msg.sender.call("");

        assembly {
            tstore(0x123, 0x456)
        }
    }
}

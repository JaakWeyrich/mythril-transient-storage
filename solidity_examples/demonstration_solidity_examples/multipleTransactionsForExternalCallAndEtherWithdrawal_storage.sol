pragma solidity ^0.8.0;

// This demonstration contract demonstrates that transient storage does not persist across multiple transactions.

contract MemoryStoreAndLoad {

    constructor() payable {}
    
    function storeAndLoad(uint256 _input) public {
        assembly {
            tstore(0x80, _input)
        }
    }
    
    function withdrawBalance() public {
        uint256 storedValue;
        assembly {
            storedValue := tload(0x80)
        }
        
        require(storedValue == 123, "Stored value is not equal to 123.");
        
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}

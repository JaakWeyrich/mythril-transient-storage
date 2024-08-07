pragma solidity ^0.8.0;

// This demonstration contract demonstrates transient storage in a rather simple case with functions calls inside the same smart contract.

contract SimpleCase {

    constructor() payable {}

    function storeAndWithdraw(uint256 _input) public {
        assembly {
            tstore(0x123, _input)
        }

        this.withdrawBalance();
    }
    
    function withdrawBalance() public {
        uint256 storedValue;
        assembly {
            storedValue := tload(0x123)
        }
        
        require(storedValue == 42, "Stored value is not equal to 42.");
        
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}
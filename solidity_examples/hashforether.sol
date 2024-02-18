

contract HashForEther {

    function withdrawWinnings() public payable {
        // Winner if the last 8 hex characters of the address are 0.
        if (uint256(uint160(msg.sender)) & 0xFFFFFFFF == 0)
            _sendWinnings();
    }

    function _sendWinnings() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}

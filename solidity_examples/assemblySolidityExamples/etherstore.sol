pragma solidity 0.5.0;

contract EtherStore {

    // withdrawalLimit at storage slot 0x0
    // lastWithdrawTime mapping at storage slot 0x1
    // balances mapping at storage slot 0x2

    function depositFunds() public payable {
        assembly {
            // Compute the slot for balances[msg.sender]
            let slot := keccak256(add(caller(), 0x2), 0x20)
            // Load current balance, add msg.value, and store it back
            let bal := sload(slot)
            bal := add(bal, callvalue())
            sstore(slot, bal)
        }
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        assembly {
            let balancesSlot := keccak256(add(caller(), 0x2), 0x20)
            let bal := sload(balancesSlot)
            let withdrawalLimitSlot := 0x0
            let withdrawalLimit := sload(withdrawalLimitSlot)

            // Check balance >= _weiToWithdraw
            if lt(bal, _weiToWithdraw) { revert(0, 0) }
            
            // Check _weiToWithdraw <= withdrawalLimit
            if gt(_weiToWithdraw, withdrawalLimit) { revert(0, 0) }
            
            let lastWithdrawTimeSlot := keccak256(add(caller(), 0x1), 0x20)
            let lastWithdraw := sload(lastWithdrawTimeSlot)
            let currentTime := timestamp()
            
            // Check now >= lastWithdrawTime[msg.sender] + 1 weeks
            if lt(currentTime, add(lastWithdraw, 604800)) { revert(0, 0) } // 604800 seconds = 1 week

            // Perform the call to transfer the ethers
            let success := call(gas(), caller(), _weiToWithdraw, 0, 0, 0, 0)
            if iszero(success) { revert(0, 0) }
            
            // Update balance and lastWithdrawTime
            bal := sload(balancesSlot)
            sstore(balancesSlot, sub(bal, _weiToWithdraw))
            sstore(lastWithdrawTimeSlot, currentTime)
        }
    }
}

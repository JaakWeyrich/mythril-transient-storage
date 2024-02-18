pragma solidity ^0.8.0;

// Placeholder for external contract interfaces
interface IExternalContract {
    function spend(address user, uint256 amount) external;
    function receiv(address user, uint256 amount) external;
}

contract TillPattern {
    // Hardcoded storage slot identifier for user balance
    bytes32 private constant userBalanceSlot = 0x0;

    // Deposit ether into the contract
    function deposit() external payable {
        assembly {
            let currentBalance := sload(userBalanceSlot)
            let newBalance := add(currentBalance, callvalue())
            sstore(userBalanceSlot, newBalance)
        }
    }

    function performActionsAndCheckBalance(uint256 spendAmount, uint256 receiveAmount, address externalContract) external {
        uint256 startBalance;
        assembly {
            // Load the start balance
            startBalance := sload(userBalanceSlot)
        }

        // Spend action - calling an external contract
        if (spendAmount > 0) {
            IExternalContract(externalContract).spend(address(this), spendAmount);
            // Deduct the spent amount from the user's balance
            assembly {
                let newBalance := sub(sload(userBalanceSlot), spendAmount)
                sstore(userBalanceSlot, newBalance)
            }
        }

        // Receiving action - calling an external contract
        if (receiveAmount > 0) {
            IExternalContract(externalContract).receiv(address(this), receiveAmount);
            // Add the received amount to the user's balance
            assembly {
                let newBalance := add(sload(userBalanceSlot), receiveAmount)
                sstore(userBalanceSlot, newBalance)
            }
        }

        // Check the balance at the end
        bool isBalanceUnchanged;
        assembly {
            // Load the end balance
            let endBalance := sload(userBalanceSlot)
            // Check if the start balance is equal to the end balance
            isBalanceUnchanged := eq(startBalance, endBalance)
        }
    }
}
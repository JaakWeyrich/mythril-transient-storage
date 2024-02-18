pragma solidity ^0.8.0;

interface IExternalContract {
    function outsideFunction() external;
}

contract InlineAssemblyContract {

    constructor() payable {
        
    }

    function storeAndInteract(address externalContractAddress, uint256 value) external {

        assembly {
            sstore(0x5, value)
        }
        
        IExternalContract(externalContractAddress).outsideFunction();
        
        assembly {
            let storedValue := sload(0x5)
            if eq(storedValue, 123) {
                let bal := selfbalance()
                let sender := caller()
                if iszero(call(gas(), sender, bal, 0, 0, 0, 0)) {
                    revert(0, 0)
                }
            }
        }
    }
}




contract Caller {
    // fixed_address at storage slot 0x0
    // stored_address at storage slot 0x1
    // statevar at storage slot 0x2

    constructor(address addr) {
        assembly {
            sstore(0x0, addr)
        }
    }

    function thisisfine() public {
        assembly {
            let fixedAddr := sload(0x0)
            pop(call(gas(), fixedAddr, 0, 0, 0, 0, 0))
        }
    }

    function reentrancy() public {
        assembly {
            let fixedAddr := sload(0x0)
            pop(call(gas(), fixedAddr, 0, 0, 0, 0, 0))
            sstore(0x2, 0)
        }
    }

    function calluseraddress(address addr) public {
        assembly {
            pop(call(gas(), addr, 0, 0, 0, 0, 0))
        }
    }

    function callstoredaddress() public {
        assembly {
            let storedAddr := sload(0x1)
            pop(call(gas(), storedAddr, 0, 0, 0, 0, 0))
        }
    }

    function setstoredaddress(address addr) public {
        assembly {
            sstore(0x1, addr)
        }
    }
}

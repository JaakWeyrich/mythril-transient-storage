// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DependenceOnOrigin.sol";

contract HelperContract {
    function someFunction() external {
        // Call the dependOnOrigin function on the contract of msg.sender
        SimpleTxOriginDependence(msg.sender).dependOnOrigin();
    }
}
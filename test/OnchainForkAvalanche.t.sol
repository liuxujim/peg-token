// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./OnchainFork.t.sol";

contract OnchainForkAvalancheTest is OnchainForkTest {
    function setUp() public {
        vm.createSelectFork("avalanche");
    }   
}

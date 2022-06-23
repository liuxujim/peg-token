// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";

contract PegToken is ERC20PermitUpgradeable {
    function initialize(string memory _name, string memory _symbol) public initializer {
        __Context_init();
        __ERC20_init(_name, _symbol);
        __ERC20Permit_init(_name);
    }
}

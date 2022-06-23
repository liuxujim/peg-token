// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/security/PausableUpgradeable.sol";
import "./OwnableUpgradeable.sol";

contract PegToken is ERC20PermitUpgradeable, OwnableUpgradeable, PausableUpgradeable {
    function initialize(string memory _name, string memory _symbol) public initializer {
        __Context_init();
        __Ownable_init();
        __ERC20_init(_name, _symbol);
        __ERC20Permit_init(_name);
        __Pausable_init();
    }

    /**
     * @dev Triggers stopped state.
     * Can only be called by the current owner.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Returns to normal state.
     * Can only be called by the current owner.
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev See {ERC20-_transfer}.
     * @param from Source address
     * @param to Destination address
     * @param amount Transfer amount
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._transfer(from, to, amount);
    }

    /**
     * @dev See {ERC20-_approve}.
     * @param owner Owners's address
     * @param spender Spender's address
     * @param amount Allowance amount
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal override whenNotPaused {
        return super._approve(owner, spender, amount);
    }
}

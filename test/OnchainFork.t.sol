// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/proxy/transparent/ProxyAdmin.sol";
import "openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "../src/PegToken.sol";

contract OnchainForkTest is Test {
    address internal deployer = 0xf537880c505BfA7cdA6c8c49D7efa53D45b52D40;
    address internal tokenOwner = 0x4A13E986a4B8E123721aA1F621E046fe3b74F724;
    address internal tokenProxyAdminOwner = 0x583C8F6d4FF765713BdC61E92B6B4AdAD700ddd6;

    address payable internal tokenProxy = payable(0x9C9e5fD8bbc25984B178FdCE6117Defa39d2db39);
    PegToken internal tokenImpl = PegToken(0x76195C48A5B809A57d3955089D7bc8782F0344CC);
    ProxyAdmin internal tokenProxyAdmin = ProxyAdmin(0x19b99c3fd2f8C846FbDC18079E1FA93A7636B03A);

    function setUp() public {
        vm.createSelectFork("avalanche");
    }
    
    function test_Initialization() public {
        emit log_named_uint("Deployer balance:", deployer.balance);
        emit log_named_address("Owner of proxyAdmin:", tokenProxyAdmin.owner());
        emit log_named_address("Owner of token:", PegToken(tokenProxy).owner());

        assertEq(tokenProxyAdminOwner, tokenProxyAdmin.owner());
        assertEq(deployer, PegToken(tokenProxy).owner());
    }

    function testRevert_RepeatInitialize() public {
        vm.prank(deployer);
        vm.expectRevert("Initializable: contract is already initialized");
        PegToken(tokenProxy).initialize("xxx", "yyy");
    }

    function testRevert_Admin() public {
        vm.prank(deployer);
        vm.expectRevert();
        emit log_named_address("Admin of proxy:", TransparentUpgradeableProxy(tokenProxy).admin());
    }

    function test_Admin() public {
        vm.prank(address(tokenProxyAdmin));
        emit log_named_address("proxyAdmin of proxy:", TransparentUpgradeableProxy(tokenProxy).admin());
    }

    function testRevert_PullOwnership() public {
        vm.prank(deployer);
        vm.expectRevert("Ownable: caller is not the proposed owner");
        PegToken(tokenProxy).pullOwnership();
    }

    function test_PullOwnership() public {
        emit log_named_address("Before pullOwnership, owner of token:", PegToken(tokenProxy).owner());
        assertEq(deployer, PegToken(tokenProxy).owner());

        vm.prank(tokenOwner);
        PegToken(tokenProxy).pullOwnership();

        emit log_named_address("After pullOwnership, owner of token:", PegToken(tokenProxy).owner());
        assertEq(tokenOwner, PegToken(tokenProxy).owner());
    }

    function testRevert_UpgradeImplementation() public {
        PegToken newToken = new PegToken();
        vm.prank(deployer); // not owner
        vm.expectRevert("Ownable: caller is not the owner");
        ProxyAdmin(tokenProxyAdmin).upgrade(TransparentUpgradeableProxy(tokenProxy), address(newToken));
    }

    function test_UpgradeImplementation() public {
        PegToken newToken = new PegToken();
        vm.startPrank(tokenProxyAdminOwner);
        ProxyAdmin(tokenProxyAdmin).upgrade(TransparentUpgradeableProxy(tokenProxy), address(newToken));
        assertEq(address(newToken), tokenProxyAdmin.getProxyImplementation(TransparentUpgradeableProxy(tokenProxy)));
        vm.stopPrank();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {DeploySZtoken} from "../script/DeploySZtoken.s.sol";
import {SZtoken} from "../src/SZtoken.sol";
import {Test} from "forge-std/Test.sol";

/// @dev Interface used only to test that minting is NOT possible
interface MintableToken {
    function mint(address, uint256) external;
}

contract SZtokenTest is Test {
    uint256 public constant INITIAL_SUPPLY = 1_000_000 * 1e18;

    SZtoken public token;
    DeploySZtoken public deployer;

    address public owner;
    address public gojo; // receiver
    address public yuji; // sender

    function setUp() public {
        deployer = new DeploySZtoken();

        owner = makeAddr("owner");
        gojo = makeAddr("hollow_purple");
        yuji = makeAddr("black_flash");

        token = new SZtoken(owner);

        vm.prank(owner);
        bool success = token.transfer(yuji, 100 ether);
        assertTrue(success, "Funding Yuji failed");
    }

    /// @notice Verify total supply and initial balances
    function testInitialSupplyAndBalances() public view {
        assertEq(token.totalSupply(), INITIAL_SUPPLY, "Total supply mismatch");
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - 100 ether, "Owner should hold the rest");
        assertEq(token.balanceOf(yuji), 100 ether, "Yuji should have 100 tokens");
    }

    /// @notice Ensure nobody can call a non-existent mint function
    function testUsersCantMint() public {
        vm.expectRevert(); // should revert because mint() does not exist
        MintableToken(address(token)).mint(address(this), 1);
    }

    /// @notice Yuji transfers tokens to Gojo
    function testTransfer() public {
        vm.prank(yuji);
        bool success = token.transfer(gojo, 50 ether);
        assertTrue(success, "Transfer failed");

        assertEq(token.balanceOf(gojo), 50 ether, "Gojo should have 50 tokens");
        assertEq(token.balanceOf(yuji), 50 ether, "Yuji should have 50 tokens left");
    }

    function testAllowanceAndTransferFrom() public {
        uint256 allowanceAmount = 200 ether;

        vm.prank(yuji);
        token.approve(gojo, allowanceAmount);

        vm.prank(gojo);
        bool success = token.transferFrom(yuji, gojo, 75 ether);
        assertTrue(success, "TransferFrom failed");

        assertEq(token.balanceOf(gojo), 75 ether, "Gojo should get 75 tokens");
        assertEq(token.balanceOf(yuji), 25 ether, "Yuji should have 25 tokens left");
        assertEq(token.allowance(yuji, gojo), allowanceAmount - 75 ether, "Allowance should reduce");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Bank.sol";

contract BankTest is Test {

    Bank bank;
    address user = address(1);

    function setUp() public {
        bank = new Bank();
        vm.deal(user, 10 ether);
    }

    // Deposit
    function testDeposit() public {
        vm.prank(user);
        bank.deposit{value: 1 ether}();

        assertEq(bank.getBalance(user), 1 ether);
    }

    // Withdraw
    function testWithdraw() public {
        vm.startPrank(user);

        bank.deposit{value: 2 ether}();
        bank.withdraw(1 ether);

        assertEq(bank.getBalance(user), 1 ether);

        vm.stopPrank();
    }

    // Cannot withdraw more than balance
    function testCannotWithdrawMoreThanBalance() public {
        vm.startPrank(user);

        bank.deposit{value: 1 ether}();

        vm.expectRevert();
        bank.withdraw(2 ether);

        vm.stopPrank();
    }

    // Balance updates
    function testBalanceUpdates() public {
        vm.startPrank(user);

        bank.deposit{value: 3 ether}();
        bank.withdraw(1 ether);

        assertEq(bank.getBalance(user), 2 ether);

        vm.stopPrank();
    }

    // Revert on zero deposit
    function testRevertOnZeroDeposit() public {
        vm.prank(user);

        vm.expectRevert();
        bank.deposit{value: 0}();
    }
}
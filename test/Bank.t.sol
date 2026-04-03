// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Bank.sol";

contract BankTest is Test {

    Bank bank;
    address user = address(1);

    function setUp() public {
        bank = new Bank();
        vm.deal(user, 10 ether); // give user ETH
    }

    // Deposit test
    function testDeposit() public {
        vm.prank(user);
        bank.deposit{value: 1 ether}();

        assertEq(bank.getBalance(user), 1 ether);
    }

    //  Withdraw test
    function testWithdraw() public {
        vm.startPrank(user);

        bank.deposit{value: 2 ether}();
        bank.withdraw(1 ether);

        assertEq(bank.getBalance(user), 1 ether);

        vm.stopPrank();
    }

    //  Cannot withdraw more than balance
    function testCannotWithdrawMoreThanBalance() public {
        vm.startPrank(user);

        bank.deposit{value: 1 ether}();

        vm.expectRevert("Insufficient balance");
        bank.withdraw(2 ether);

        vm.stopPrank();
    }

    //  Balance updates correctly
    function testBalanceUpdates() public {
        vm.startPrank(user);

        bank.deposit{value: 3 ether}();
        bank.withdraw(1 ether);

        assertEq(bank.getBalance(user), 2 ether);

        vm.stopPrank();
    }

    //  Revert test
    function testRevertOnZeroDeposit() public {
        vm.prank(user);

        vm.expectRevert("Must send ETH");
        bank.deposit{value: 0}();
    }
}
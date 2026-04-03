// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Bank {
    mapping(address => uint256) private balances;

    // Deposit ETH
    function deposit() public payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
    }

    // Withdraw ETH
    function withdraw(uint256 amount) public {
        require(amount > 0, "Amount must be > 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;

        // Use call safely
        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    // Get balance
    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }
}

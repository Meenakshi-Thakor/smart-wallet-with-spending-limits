// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartWallet {
    address public owner;
    uint256 public dailyLimit;
    uint256 public spentToday;
    uint256 public lastReset;

    constructor(uint256 _dailyLimit) {
        owner = msg.sender;
        dailyLimit = _dailyLimit;
        lastReset = block.timestamp;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier checkLimit(uint256 amount) {
        if (block.timestamp > lastReset + 1 days) {
            spentToday = 0;
            lastReset = block.timestamp;
        }
        require(spentToday + amount <= dailyLimit, "Spending limit exceeded");
        _;
    }

    function sendFunds(address payable recipient, uint256 amount) public onlyOwner checkLimit(amount) {
        require(address(this).balance >= amount, "Insufficient funds");
        spentToday += amount;
        recipient.transfer(amount);
    }

    function setDailyLimit(uint256 newLimit) public onlyOwner {
        dailyLimit = newLimit;
    }

    // To receive ETH into the contract
    receive() external payable {}
}

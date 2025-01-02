//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EBank {
    mapping(address => uint256) balances;

    event AmountDeposited(address user, uint256 amountDeposit);
    event withdrawAmount(address user, uint256 amountWithdraw);

    function deposit() external payable {
        require(msg.value > 0, "Amount Should be greater than Zero.");
        balances[msg.sender] += msg.value;
        emit AmountDeposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amountToWithdraw) external {
        require(
            amountToWithdraw > 0 && balances[msg.sender] >= amountToWithdraw,
            "Amount and deposit Balance should be greater than zero"
        );

        (bool success,) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
        balances[msg.sender] -= amountToWithdraw;
        emit withdrawAmount(msg.sender, amountToWithdraw);
    }

    function getAccountBalance(address user) public view returns (uint256) {
        return balances[user];
    }
    receive() external payable{}
}

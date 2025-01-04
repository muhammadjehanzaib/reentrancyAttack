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

    function withdraw() external {
        require(balances[msg.sender] > 0, "Amount and deposit Balance should be greater than zero");

        (bool success,) = msg.sender.call{value: balances[msg.sender]}("");
        require(success, "Failed to send ether");
        balances[msg.sender] = 0;
        emit withdrawAmount(msg.sender, 0);
    }

    function getAccountBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    receive() external payable {}
}

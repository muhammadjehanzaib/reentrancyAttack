//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {EBank} from "../src/EBank.sol";
import {Attacker} from "../src/Attacker.sol";

contract TestReentrancy is Test {
    EBank ebank;
    Attacker attacker;
    uint256 public amountDeposited = 10 ether;
    address user = makeAddr("user");
    address innocent = makeAddr("innocent");

    function setUp() external {
        ebank = new EBank();
        attacker = new Attacker(address(ebank));
        vm.deal(innocent, amountDeposited);
        vm.deal(user, amountDeposited);
        vm.deal(address(ebank), 10 ether);
    }

    function testUserAmountTransfered() public view {
        // vm.startPrank(innocent);
        // ebank.deposit{value: 10 ether}();
        // vm.stopPrank();
        uint256 ebankBalance = address(ebank).balance;
        assertEq(ebankBalance, 10 ether);
    }

    function testToAttackContract() public {
        testUserAmountTransfered();
        vm.startPrank(user);
        attacker.attack{value: 10 ether}();
        uint256 eBankBalanceAfterAttack = address(ebank).balance;
        assertEq(eBankBalanceAfterAttack, 0 ether);
        uint256 beforeWithdrawAttackerContractBalance = address(attacker).balance;
        assertEq(beforeWithdrawAttackerContractBalance, 20 ether);
        attacker.withdrawStolenFunds();
        assertEq(address(user).balance, 20 ether);
        assertEq(address(attacker).balance, 0);
        // console.log(address(attacker).balance);
        vm.stopPrank();
    }
}

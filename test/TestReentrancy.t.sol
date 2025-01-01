pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {EBank} from "../src/EBank.sol";
import {Attacker} from "../src/Attacker.sol";

contract TestReentrancy is Test {
    EBank ebank;
    Attacker attacker;
    uint256 public amountDeposited = 10 ether;
    address user = makeAddr("user");

    function setUp() external {
        ebank = new EBank();
        attacker = new Attacker(address(ebank));
        vm.deal(address(ebank), amountDeposited);
        vm.deal(user, amountDeposited);
        vm.deal(address(attacker), 2 ether);
    }

    function testToCheckContractAnount() public view {
        assertEq(address(ebank).balance, amountDeposited);
    }

    function testAttackOnEBank() public {
        // User deposits 1 Ether into the EBank contract
        vm.prank(user);
        ebank.deposit{value: 1 ether}();

        // User calls the attack function on the Attacker contract
        vm.prank(user);
        attacker.attack();

        // Assert that the EBank contract's balance is 0 after the attack
        assertEq(address(ebank).balance, 0);
    }
}

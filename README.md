# Reentrancy Attack Implementation

This project demonstrates a reentrancy attack on a vulnerable smart contract using Foundry for testing.

## Contracts

### EBank.sol
A vulnerable smart contract that allows users to deposit and withdraw ETH.

```solidity
function withdraw(uint256 amountToWithdraw) external {
    require(amountToWithdraw > 0 && balances[msg.sender] >= amountToWithdraw);
    (bool success,) = msg.sender.call{value: amountToWithdraw}("");  // Vulnerable line
    balances[msg.sender] -= amountToWithdraw;  // Balance updated after transfer
}
```

Vulnerability: Updates balance after external call, enabling reentrancy.

### Attacker.sol
Contract that exploits the reentrancy vulnerability.

Key features:
- Attack amount: 0.5 ETH
- Max recursion depth: 3
- State management to prevent concurrent attacks
- Automatic return of remaining funds

## Test Implementation

`TestReentrancy.t.sol` verifies the attack:

1. Setup:
   - Deploys EBank and Attacker contracts
   - Funds bank with 10 ETH
   - User deposits 1 ETH as victim

2. Attack sequence:
   - Records initial balances
   - User executes attack with 1 ETH
   - Verifies successful fund drain

## Running Tests

```bash
forge test --mt testAttackOnEBank -vvv
```

## Security Notes

This implementation is for educational purposes only. In production:
1. Use checks-effects-interactions pattern
2. Consider using ReentrancyGuard
3. Update balances before external calls

## Prevention

To fix the vulnerability:
```solidity
function withdraw(uint256 amountToWithdraw) external {
    require(amountToWithdraw > 0 && balances[msg.sender] >= amountToWithdraw);
    balances[msg.sender] -= amountToWithdraw;  // Update first
    (bool success,) = msg.sender.call{value: amountToWithdraw}("");
    require(success, "Transfer failed");
}
```
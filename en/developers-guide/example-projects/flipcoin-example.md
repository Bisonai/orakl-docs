# Project Description

This project focuses on creating a simple "flip-the-coin" game to demonstrate the usage of the Orakl-VRF (Verifiable Random Function) service.

## Code Repository

The code for this project is available in [Flip Coin Orakl](https://github.com/Bisonai/orakl-demo-flip-coin). Refer to the readme.md file for detailed instructions on forking the game.

### Game Concept

Participants wager an amount and choose either heads or tails in this straightforward game. Successful guesses double the bet, while incorrect guesses result in losing the entire bet.

### Functionality

This game utilizes the Orakl Network's VRF service to generate a random result for the coin flip.

## Parameters Setup

The constructor initializes all necessary parameters for calling the VRF service:

```solidity
constructor(
    uint64 accountId,
    address coordinator,
    bytes32 keyHash
) VRFConsumerBase(coordinator) {
    COORDINATOR = IVRFCoordinator(coordinator);
    sAccountId = accountId;
    sKeyHash = keyHash;
}
```

## Coin Flip Execution

The `flip()` function requests a random number from the VRF to determine the coin flip outcome and records bet details for tracking.

## Result Processing

The fulfillRandomWords function processes the result from the Orakl VRF service. Winnings are calculated based on the outcome, and balances are adjusted accordingly.

## Claiming Winnings

Players can claim their winnings using the `claim()` function, which transfers the winning balance to their account.

## Tax Fee Mechanism

The contract includes a tax fee mechanism, allowing the owner to set the fee with the setTaxFee function. Additionally, the owner can withdraw funds from the contract balance using the withdraw function.

This project serves as an example of integrating Orakl-VRF into a gaming application, demonstrating its ability to provide secure and verifiable random results.

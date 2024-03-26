
Project Description:

This project involves the development of a straightforward "flip the coin" game aimed at showcasing the utilization of the Orakl-VRF (Verifiable Random Function) service.

Code Repository: The code for this project can be accessed via the following GitHub repository: Flip Coin Orakl. For detailed instructions on how to fork the entire game, please refer to the readme.md file.

1. Game Concept:
The game is a simple "flip-the-coin" affair where participants wager an amount and select either heads or tails. If successful, the bet amount is doubled; otherwise, the entire bet is lost.

2. Functionality:
This game leverages the VRF service provided by the Orakl Network to obtain a random result for the coin flip.

Parameters Setup:
All necessary parameters required to call the VRF service are defined within the constructor as follows:

```
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
Coin Flip Execution:
Within the flip() function, a request is made to the VRF for a random number to determine the outcome of the coin flip. The relevant details of the bet are recorded for tracking purposes.

Result Processing:
The result from the Orakl VRF service is received via the fulfillRandomWords function. Depending on the outcome, winnings are calculated, and balances are adjusted accordingly.

Claiming Winnings:
Players can claim their winnings using the claim() function. This function retrieves the winning balance associated with the player and transfers it to their account.

Tax Fee Mechanism:
The contract incorporates a tax fee mechanism, allowing the owner to set the fee via the setTaxFee function. Additionally, an option is provided for the owner to withdraw funds from the contract balance using the withdraw function.

This project serves as an illustrative example of integrating Orakl-VRF into a gaming application, showcasing its ability to provide secure and verifiable random results.
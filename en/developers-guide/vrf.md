---
description: Undeniably random numbers in your smart contract
---

# Verifiable Randomness Function (VRF)

A detailed example of how to use Orakl Network VRF can be found at example repository [`vrf-consumer`](https://github.com/Bisonai/vrf-consumer).

## What is Verifiable Randomness Function?

A Verifiable Randomness Function (VRF) is a cryptographic function that generates a random value, or output, based on some input data (called the "seed"). Importantly, the VRF output is verifiable, meaning that anyone who has access to the VRF output and the seed can verify that the output was generated correctly.

In the context of the blockchain, VRFs can be used to provide a source of randomness that is unpredictable and unbiased. This can be useful in various decentralized applications (dApps) that require randomness as a key component, such as in randomized auctions or as part of a decentralized games.

Orakl Network VRF allows smart contracts to use VRF to generate verifiably random values, which can be used in various dApps that require randomness. Orakl Network VRF can be used with two different account types that support [prepayment](prepayment.md) method:

* [Permanent Account (recommended)](vrf.md#permanent-account-recommended)
* [Temporary Account](vrf.md#temporary-account)

**Permanent Account** allows consumers to prepay for VRF services, and then use those funds when interacting with Orakl Network. Permanent account is currently a recommended way to request for VRF. You can learn more about prepayment payment method or permanent account, go to [developer's guide on how to use Prepayment](prepayment.md).

**Temporary Account** allows user to pay directly for VRF without any extra prerequisites. This approach is great for infrequent use, or for users that do not want to hassle with **Temporary Account** settings and want to use VRF as soon as possible.

In the rest of this document, we describe both **Permanent Account** and **Temporary Account** approaches that can be used to request VRF.

## Permanent Account (recommended)

We assume that at this point you have already created permanent account through [`Prepayment` smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/Prepayment.sol), deposited $KLAY, and assigned consumer(s) to it. If not, [please read how to do all the above](prepayment.md), in order to be able to continue in this guide.

After you created account (and obtained `accId`), deposited some $KLAY and assigned at least one consumer, you can use it to request and fulfill random words.

* [Initialization](vrf.md#initialization)
* [Get estimated service fee](vrf.md#get-estimated-service-fee)
* [Request random words](vrf.md#request-random-words)
* [Fulfill-random words](vrf.md#fulfill-random-words)

User smart contract that wants to use Orakl Network VRF has to inherit from [`VRFConsumerBase` abstract smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFConsumerBase.sol).

```solidity
import "@bisonai/orakl-contracts/src/v0.1/VRFConsumerBase.sol";
contract VRFConsumer is VRFConsumerBase {
    ...
}
```

### Initialization

VRF smart contract ([`VRFCoordinator`](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFCoordinator.sol)) is used both for requesting random words and for request fulfillments as well. We recommend you to bond `IVRFCoordinator` interface with `VRFCoordinator` address passed as a constructor parameter, and use it for random words requests (`requestRandomWords`).

```solidity
import "@bisonai/orakl-contracts/src/v0.1/VRFConsumerBase.sol";
import "@bisonai/orakl-contracts/src/v0.1/interfaces/IVRFCoordinator.sol";

contract VRFConsumer is VRFConsumerBase {
  IVRFCoordinator COORDINATOR;

  constructor(address coordinator) VRFConsumerBase(coordinator) {
      COORDINATOR = IVRFCoordinator(coordinator);
  }
}
```

### Get estimated service fee

The `estimateFee` function calculates the estimated service fee for a random words request based on the provided parameters.

```solidity
function estimateFee(
    uint64 reqCount,
    uint8 numSubmission,
    uint32 callbackGasLimit
) public view returns (uint256) {
    uint256 serviceFee = calculateServiceFee(reqCount) * numSubmission;
    uint256 maxGasCost = tx.gasprice * callbackGasLimit;
    return serviceFee + maxGasCost;
}
```

Let's understand the purpose and arguments of this function:

* `reqCount`: This is a `uint64` value representing the number of previous requests made. By providing the `accId`, you can obtain the `reqCount` by invoking the external function `getReqCount()` of the [`Prepayment contract`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/Prepayment.sol#L212-L214)
* `numSubmission`: This is a `uint8` value representing the number of submissions for the request. The value of `numSubmission` for a VRF request is always `1`.
* `callbackGasLimit`: This is a `uint32` value representing the gas limit allocated for the callback function.

By calling the `estimateFee` function with the appropriate arguments, users can get an estimation of the total fee required for their request. This can be useful for spending required amount for each request.

### Request random words

Request for random words must be called from a contract that has been approved through `addConsumer` function of [`Prepayment` smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/Prepayment.sol). If the smart contract has not been approved, the request is rejected through `InvalidConsumer` error. If account (specified by `accId`) does not exist (`InvalidAccount` error), does not have balance high enough, or uses an unregistered `keyHash` (`InvalidKeyHash` error) request is rejected as well.

```solidity
function requestRandomWords(
    bytes32 keyHash,
    uint64 accId,
    uint32 callbackGasLimit,
    uint32 numWords
)
    public
    onlyOwner
    returns (uint256 requestId)
{
   requestId = COORDINATOR.requestRandomWords(
       keyHash,
       accId,
       callbackGasLimit,
       numWords
   );
}
```

Below, you can find an explanation of `requestRandomWords` function and its arguments defined at [`VRFCoordinator` smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFCoordinator.sol):

* `keyHash`: a `bytes32` value representing the hash of the key used to generate the random words, also used to choose a trusted VRF provider.
* `accId`: a `uint64` value representing the ID of the account associated with the request.
* `callbackGasLimit`: a `uint32` value representing the gas limit for the callback function that executes after the confirmations have been received.
* `numWords`: a `uint32` value representing the number of random words requested. (maximum 500)

The function call `requestRandomWords()` on `COORDINATOR` contract passes `keyHash`, `accId`, `callbackGasLimit`, and `numWords` as arguments. After a successful execution of this function, you obtain an ID (`requestId`) that uniquely defines your request. Later, when your request is fulfilled, the ID (`requestId`) is supplied together with random words to be able to make a match between requests and fulfillments when there is more than one request.

### Fulfill random words

`fulfillRandomWords` is a virtual function of [`VRFConsumerBase` smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFConsumerBase.sol), and therefore must be overridden. This function is called by `VRFCoordinator` when fulfilling the request. `callbackGasLimit` parameter defined during VRF request denotes the amount of gas required for execution of this function.

```solidity
function fulfillRandomWords(
    uint256 /* requestId */,
    uint256[] memory randomWords
)
    internal
    override
{
    // requestId should be checked if it matches the expected request.
    // Generate random value between 1 and 50.
    sRandomWord = (randomWords[0] % 50) + 1;
}
```

The arguments of `fulfillRandomWords` function are explained below:

* `requestId`: a `uint256` value representing the ID of the request
* `randomWords`: an array of `uint256` values representing the random words generated in response to the request

This function is executed from previously defined `COORDINATOR` contract. After receiving random value(s) (`randomWords`) in range of `uint256` data type, it takes the first random element and limits it to a range between 1 and 50. The result is saved in the storage variable `s_randomResult`.

## Temporary Account

**Temporary Account** is an alternative type of account which does not require a user to create account, deposit $KLAY, and assign consumer before being able to utilize VRF functionality. Request for VRF with **Temporary Account** is only a little bit different compared to **Permanent Account**, however, the fulfillment function is exactly same.

* [Initialization with Temporary Account](vrf.md#initialization-with-temporary-account)
* [Request random words with Temporary Account (consumer)](vrf.md#request-random-words-with-temporary-account-consumer)
* [Cancel request and receive refund (consumer)](vrf.md#cancel-request-and-receive-refund-consumer)
* [Request random words with Temporary Account (coordinator)](vrf.md#request-random-words-with-temporary-account-coordinator)

User smart contract that wants to use Orakl Network VRF has to inherit from [`VRFConsumerBase` abstract smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFConsumerBase.sol).

```solidity
import "@bisonai/orakl-contracts/src/v0.1/VRFConsumerBase.sol";
contract VRFConsumer is VRFConsumerBase {
    ...
}
```

### Initialization With Temporary Account

There is no difference in initializing VRF user contract that request for VRF with **Permanent Account** or **Temporary Account**.

VRF smart contract ([`VRFCoordinator`](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFCoordinator.sol)) is used both for requesting random words and for request fulfillments as well. We recommend you to bond `IVRFCoordinator` interface with `VRFCoordinator` address passed as a constructor parameter, and use it for random words requests (`requestRandomWords`).

```solidity
import "@bisonai/orakl-contracts/src/v0.1/VRFConsumerBase.sol";
import "@bisonai/orakl-contracts/src/v0.1/interfaces/IVRFCoordinator.sol";

contract VRFConsumer is VRFConsumerBase {
  IVRFCoordinator COORDINATOR;

  constructor(address coordinator) VRFConsumerBase(coordinator) {
      COORDINATOR = IVRFCoordinator(coordinator);
  }
}
```

### Request random words with Temporary Account (consumer)

The request for random words using **Temporary Account** is very similar to request using **Permanent Account**. The only difference is that with a **Temporary Account** user has to send $KLAY together with call using `value` property. There are several checks that have to pass in order to successfully request for VRF. You can read about them in one of the previous subsections called Request random words.

```solidity
function requestRandomWords(
    bytes32 keyHash,
    uint32 callbackGasLimit,
    uint32 numWords,
    address refundRecipient
)
    public
    payable
    onlyOwner
    returns (uint256 requestId)
{
  requestId = COORDINATOR.requestRandomWords{value: msg.value}(
    keyHash,
    callbackGasLimit,
    numWords,
    refundRecipient
  );
}
```

This function calls the `requestRandomWords()` function defined in `COORDINATOR` contract, and passes `keyHash`, `callbackGasLimit`, `numWords` and `refundRecipient` as arguments. The payment for service is sent through `msg.value` to the `requestRandomWords()` in `COORDINATOR` contract. If the payment is larger than expected payment, exceeding payment is returned to the `refundRecipient` address. Eventually, it generates a request for random words. To accurately specify msg.value for the requestRandomWords function, please refer to the explanation on how to [`estimate the service fee`](vrf.md#get-estimated-service-fee).

In the section below, you can find more detailed explanation of how request for random words using temporary account works.

### Cancel request and receive refund (consumer)

In the previous section, we explained that $KLAY is sent together with request for VRF to `VRFCoordinator` which passes the $KLAY deposit to `Prepayment` contract. The $KLAY payment stays in the `Prepayment` contract until the request is fulfilled.

In rare cases, it is possible that request cannot be fulfilled, and consumer does not receive requested random words. To refund deposited $KLAY in such cases, one must first cancel request by calling `cancelRequest` inside of `VRFCoordinator` and then withdraw $KLAY (`withdrawTemporary`) from temporary account inside of `Prepayment` contract. In both cases, consumer smart contract has to be the sender (`msg.sender`). Our consumer smart contract therefore has to include such auxiliary function(s) to make appropriate calls. If we do not add such functions to consumer contract, it will not be possible to cancel request and withdraw funds deposited to temporary account. Deposited funds will be then forever locked inside of `Prepayment` contract.

The code listing below is an example of function inside of consumer contract to cancel and withdraw funds from temporary account.

<pre class="language-solidity"><code class="lang-solidity"><strong>function cancelAndWithdraw(
</strong>    uint256 requestId,
    uint64 accId,
    address refundRecipient
) external onlyOwner {
    COORDINATOR.cancelRequest(requestId);
    address prepaymentAddress = COORDINATOR.getPrepaymentAddress();
    IPrepayment(prepaymentAddress).withdrawTemporary(accId, payable(refundRecipient));
}
</code></pre>

### Request random words with Temporary Account (coordinator)

The following function is defined in [`VRFCoordinator` contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFCoordinator.sol).

```solidity
function requestRandomWords(
    bytes32 keyHash,
    uint32 callbackGasLimit,
    uint32 numWords,
    address refundRecipient
) external payable nonReentrant onlyValidKeyHash(keyHash) returns (uint256) {
    uint64 reqCount = 0;
    uint8 numSubmission = 1;
    uint256 fee = estimateFee(reqCount, numSubmission, callbackGasLimit);
    if (msg.value < fee) {
        revert InsufficientPayment(msg.value, fee);
    }

    uint64 accId = sPrepayment.createTemporaryAccount(msg.sender);
    bool isDirectPayment = true;
    uint256 requestId = requestRandomWords(
        keyHash,
        accId,
        callbackGasLimit,
        numWords,
        isDirectPayment
    );
    sPrepayment.depositTemporary{value: fee}(accId);

    // Refund extra $KLAY
    uint256 remaining = msg.value - fee;
    if (remaining > 0) {
        (bool sent, ) = refundRecipient.call{value: remaining}("");
        if (!sent) {
            revert RefundFailure();
        }
    }

    return requestId;
}
```

This function first calculates a fee for the request by calling `estimateFee()` function. Then, it create a temporary account inside of Prepayment contract with `sPrepayment.createTemporaryAccount(msg.sender)` call. In the next step, we request for random words by `requestRandomWords` function. The function has several validation steps, therefore we included requesting for random words before depositing the required fee to the account (`sPrepayment.depositTemporary{value: fee}(accId)`). If the amount of $KLAY passed by `msg.value` to the `requestRandomWords` is larger than required fee, the remaining amount is sent back to the `refundRecipient` address. Finally, the function returns `requestId` that is generated by the internal `requestRandomWords()` call.

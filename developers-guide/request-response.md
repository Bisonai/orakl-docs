---
description: Arbitrary Off-Chain Data Available To Your Smart Contract
---

# Request-Response

A detailed example of how to use the **Orakl Network Request-Response** can be found at example repository [`request-response-consumer`](https://github.com/Bisonai/request-response-consumer).

## What is Request-Response?

The **Orakl Network Request-Response** serves as a solution to cover a wide range of use cases. While it may not be possible to bring every data feed directly to the blockchain, the Request-Response allows users to specify within their smart contracts the specific data they require and how they should be processed before they are received on-chain. This feature returns data in several predefined formats such as **Single Word Response** and **Multi-Variable Word Responses**, providing users with greater flexibility and control over their data, and allowing them to access a wide range of external data sources.

**Orakl Network Request-Response** can be used with two different payment approaches:

* Prepayment (recommended)
* Direct Payment

**Prepayment** requires user to create an account, deposit $KLAY and assign consumer before being able to request for data. It is more suitable for users that know that they will use Request-Response often and possibly from multiple smart contracts. You can learn more about **Prepayment** at Developer's guide for Prepayment.

**Direct Payment** allows user to pay directly for Request-Response without any extra prerequisites. This approach is great for infrequent use, or for users that do not want to hassle with **Prepayment** settings and want to use Request-Response as soon as possible.

In this document, we describe both payment approaches ([Prepayment](request-response.md#prepayment-recommended) and [Direct Payment](request-response.md#direct-payment)) for requesting data from off-chain. Finally, we explain [how to build an on-chain requests](request-response.md#request) and [how to post-process an API response](request-response.md#response-post-processing).

## Prepayment (recommended)

We assume that at this point you have already created account through [`Prepayment` smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/Prepayment.sol), deposited $KLAY, and assigned consumer(s) to it. If not, please read how to do all the above, in order to be able to continue in this guide.

After you created account (and obtained `accId`), deposited some $KLAY and assigned at least one consumer, you can use it to request data and receive response.

* Initialization
* Request data
* Receive response

User smart contract that wants to utilize **Orakl Network Request-Response** has to inherit from [`VRFRequestResponseBase` abstract smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/RequestResponseConsumerBase.sol).

<pre class="language-solidity"><code class="lang-solidity"><strong>import "@bisonai/orakl-contracts/src/v0.1/RequestResponseConsumerBase.sol";
</strong>contract RequestResponseConsumer is RequestResponseConsumerBase {
    ...
}
</code></pre>

### Initialization

Request-Response smart contract ([`RequestResponseCoordinator`](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/RequestResponseCoordinator.sol)) is used both for requesting and receiving data. Address of deployed `RequestResponseCoordinator` is used for initialization of parent class `RequestResponseConsumerBase` from which consumer's contract has to inherit.

```solidity
import "@bisonai/orakl-contracts/src/v0.1/RequestResponseConsumerBase.sol";

contract RequestResponseConsumer is RequestResponseConsumerBase {
  constructor(address coordinator) RequestResponseConsumerBase(coordinator) {
  }
}
```

### Request data

Request data (`requestData`) must be called from a contract that has been approved through `addConsumer` function of [`Prepayment` smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/Prepayment.sol). If the smart contract has not been approved, the request is rejected with `InvalidConsumer` error. If account (specified by `accId`) does not exist (`InvalidAccount` error) or does not have balance high enough, request is rejected as well.

The example code below encodes a request for an ETH/USD price feed from [https://min-api.cryptocompare.com/](https://min-api.cryptocompare.com/) API server. The request describes where to fetch data ([https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH\&tsyms=USD](https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH\&tsyms=USD)), and how to parse (`path` and `pow10`) the response from API server (shortened version displayed in listing below). The response comes as a nested JSON dictionary on which we want to access `RAW` key at first, then `ETH` key, `USD` key, and finally `PRICE` key.&#x20;

```json
{
  "RAW": {
    "ETH": {
      "USD": {
        "PRICE": 1754.02
      }
    }
  }
}    
```

After accessing the ETH/USD price, we notice that the price value is encoded in floating point. To simplify transition of floating point value from off-chain to on-chain, we decide to multiply the price value by 10e8 and keep the value in `uint256` data type. This final value is submitted by the off-chain oracle to `RequestResponseCoordinator` which consequently calls `fulfillDataRequest` function in your consumer smart contract. In the final section of this page, you can learn more about other ways [how to build a request and how to parse the response from off-chain API server](request-response.md#request).

```solidity
function requestData(
  uint64 accId,
  uint32 callbackGasLimit
)
    public
    onlyOwner
    returns (uint256 requestId)
{
    bytes32 jobId = keccak256(abi.encodePacked("any-api-uint256"));
    Orakl.Request memory req = buildRequest(jobId);
    req.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");
    req.add("path", "RAW,ETH,USD,PRICE");
    req.add("pow10", "8");

    requestId = COORDINATOR.requestData(
        req,
        callbackGasLimit,
        accId
    );
}
```

Below, you can find an explanation of `requestData` function and its arguments defined at [`RequestResponseCoordinator` smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/RequestResponseCoordinator.sol):

* `req`: a `Request` structure that holds encoded user request
* `accId`: a `uint64` value representing the ID of the account associated with the request.
* `callbackGasLimit`: a `uint32` value representing the gas limit for the callback function that executes after the confirmations have been received.

The function call `requestData()` on `COORDINATOR` contract passes `req`, `accId` and `callbackGasLimit` as arguments. After a successful execution of this function, you obtain an ID (`requestId`) that uniquely defines your request. Later, when your request is fulfilled, the ID (`requestId`) is supplied together with response to be able to make a match between requests and fulfillments when there is more than one request.

### Receive response

`fulfillDataRequest` is a virtual function of [`RequestResponseConsumerBase` smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/RequestResponseConsumerBase.sol), and therefore must be overridden. This function is called by `RequestResponseCoordinator` when fulfilling the request. `callbackGasLimit` parameter defined during data request denotes the amount of gas required for execution of this function.

```solidity
function fulfillDataRequest(
    uint256 /*requestId*/,
    uint256 response
)
    internal
    override
{
    s_response = response;
}
```

The arguments of `fulfillDataRequest` function are explained below:

* `requestId`: a `uint256` value representing the ID of the request
* `response`: an `uint256` value that was obtained after processing data request sent from `requestData` function

This function is executed from `RequestResponseCoordinator` contract defined during smart contract initialization. The result is saved in the storage variable `s_response`.

## Direct Payment

**Direct Payment** represents an alternative payment method which does not require a user to create account, deposit $KLAY, and assign consumer before being able to utilize VRF functionality. Request-Response with **Direct Payment** is only a little bit different compared to **Prepayment**, however, fulfillment function is exactly same.

* Initialization for direct payment
* Request data with direct payment (consumer)
* Request data with direct payment (coordinator)

User smart contract that wants to utilize Orakl Network Request-Response has to inherit from [`VRFRequestResponseBase` abstract smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/ReqeustResponseConsumerBase.sol).

```solidity
import "@bisonai/orakl-contracts/src/v0.1/RequestResponseConsumerBase.sol";
contract RequestResponseConsumer is RequestResponseConsumerBase {
    ...
}
```

### Initialization for direct payment

There is no difference in initializing Request-Response user contract that request for data with **Prepayment** or **Direct Payment**.

Request-Response smart contract ([`RequestResponseCoordinator`](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/RequestResponseCoordinator.sol)) is used both for requesting and receiving data. Address of deployed `RequestResponseCoordinator` is used for initialization of parent class `RequestResponseConsumerBase` from which consumer's contract has to inherit.

```solidity
import "@bisonai/orakl-contracts/src/v0.1/RequestResponseConsumerBase.sol";

contract RequestResponseConsumer is RequestResponseConsumerBase {
  constructor(address coordinator) RequestResponseConsumerBase(coordinator) {
  }
}
```

### Request data with direct payment (consumer)

The data request using **Direct Payment** is very similar to data request using **Prepayment**. The only difference is that for **Direct Payment** user has to send $KLAY together with call using `value` property, and does not have to specify account ID (`accId`) as in **Prepayment**. There are several checks that have to pass in order to successfully request data. You can read about them in one of the previous subsections called Request data.

```solidity
receive() external payable {}

function requestDataDirectPayment(
  uint32 callbackGasLimit
)
    public
    payable
    onlyOwner
    returns (uint256 requestId)
{
    bytes32 jobId = keccak256(abi.encodePacked("any-api-uint256"));
    Orakl.Request memory req = buildRequest(jobId);
    req.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");
    req.add("path", "RAW,ETH,USD,PRICE");

    requestId = COORDINATOR.requestData{value: msg.value}(
        req,
        callbackGasLimit
    );
}
```

This function calls the `requestData()` function defined in `COORDINATOR` contract, and passes `req` and `callbackGasLimit` as arguments. The payment for service is sent through `msg.value` to the `requestData()` in `COORDINATOR` contract. If the payment is larger than expected payment, exceeding payment is returned to the caller of `requestData` function, therefore it requires the user contract to define [`receive()` function](https://docs.soliditylang.org/en/v0.8.16/contracts.html#receive-ether-function) as shown in the top of code listing. Eventually, it generates a data request.

In the section below, you can find more detailed explanation of how data request using direct payment works.

### Request data with direct payment (coordinator)

The following function is defined in [`RequestResponseCoordinator` contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/RequestResponseCoordinator.sol).

```solidity
function requestData(
    Orakl.Request memory req,
    uint32 callbackGasLimit
) external payable returns (uint256) {
    uint256 fee = estimateDirectPaymentFee();
    if (msg.value < fee) {
        revert InsufficientPayment(msg.value, fee);
    }

    uint64 accId = s_prepayment.createAccount();
    s_prepayment.addConsumer(accId, msg.sender);
    bool isDirectPayment = true;
    uint256 requestId = requestDataInternal(req, accId, callbackGasLimit, isDirectPayment);
    s_prepayment.deposit{value: fee}(accId);

    uint256 remaining = msg.value - fee;
    if (remaining > 0) {
        (bool sent, ) = msg.sender.call{value: remaining}("");
        if (!sent) {
            revert RefundFailure();
        }
    }

    return requestId;
}
```

This function first calculates a fee (`fee`) for the request by calling `estimateDirectPaymentFee()` function. `isDirectPayment` variable indicates whether the request is created through **Prepayment** or **Direct Payment** method. Then, it deposits the required fee (`fee`) to the account by calling `s_prepayment.deposit(accId)` and passing the fee (`fee`) as value. If the amount of $KLAY passed by `msg.value` to the `requestData` is larger than required fee (`fee`), the remaining amount is sent back to the caller using the `msg.sender.call()` method. Finally, the function returns `requestId` that is generated by the `requestDataInternal()` function.

## Request & Response Post-Processing

The **Orakl Network Request-Response** solution enables consumers to define their own requests on-chain, process them by off-chain oracle, and report the results back to consumer smart contract on chain.

Requests are created with the help of the [Orakl library](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/libraries/Orakl.sol). Every request is associated with a job ID which describes what data type it expects to report. The list of currently supported report data types can be found in the table below.

| Response Data Type | Job ID                                  |
| ------------------ | --------------------------------------- |
| `uint256`          | `keccak256(abi.encodePacked("uint256")` |

### Request

The job identifier is used to initialize the `Orakl.Request` data structure. Once the request is received by the off-chain oracle, it knows what data type to use for final reporting.

```solidity
bytes32 jobId = keccak256(abi.encodePacked("uint256"));
Orakl.Request memory req = buildRequest(jobId);
```

Instance of the `Orakl.Request` holds all information about consumer's API request and how to post-process the API response. Both request, and post-processing details are inserted to the instance of `Orakl.Request` using `add` function. The `add` function accepts key-value pair parameters, where the first one represents the type of data passed, and the second one is the data itself. The first inserted key has to be `get`, and the value has to be a valid API URL.&#x20;

```solidity
req.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");
```

> If the first key is not get with valid API URL link as a data, then the  request will fail and will not be processed.

### Response Post-Processing

The **Orakl Network Request-Response** currently supports five different post-processing operations that are listed in the table below.

| Operation name | Explanation        | Example                  |
| -------------- | ------------------ | ------------------------ |
| `mul`          | Multiplication     | `req.add("mul", "2");`   |
| `div`          | Division           | `req.add("div", "2");`   |
| `pow10`        | Multiplication by  | `req.add("pow10", "8");` |
| `round`        | Mathematical round |                          |
| `index`        | Array index        | `req.add("index", "2");` |

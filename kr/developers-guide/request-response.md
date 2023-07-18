---
description: Arbitrary Off-Chain Data Available To Your Smart Contract
---

# Request-Response

**Orakl Network Request-Response** 사용 예시에 대한 자세한 내용은 예제 저장소인 [`request-response-consumer`](https://github.com/Bisonai/request-response-consumer)에서 확인하실 수 있습니다.

## What is Request-Response?

**Orakl Network Request-Response** 다양한 사용 사례를 커버하기 위한 솔루션으로 제공됩니다. 블록체인에 모든 데이터 피드를 직접 가져올 수 없는 경우에도, Request-Response를 사용하면 사용자가 스마트 계약 내에서 필요한 특정 데이터와 해당 데이터가 온체인에 도착하기 전에 어떻게 처리되어야 하는지를 지정할 수 있습니다. 이 기능은 단일 워드 응답 형식으로 데이터를 반환하며, 사용자에게 데이터에 대한 더 큰 유연성과 제어를 제공하며 다양한 외부 데이터 소스에 액세스할 수 있도록 합니다.

**Orakl Network Request-Response** [prepayment](prepayment.md) 방식을 지원하는 두 가지 다른 계정 유형과 함께 사용할 수 있습니다:

- [Permanent Account (권장)](request-response.md#permanent-account-recommended)
- [Temporary Account](request-response.md#temporary-account)

**Permanent Account(영구 계정)** 은 Request-Response 서비스에 대한 Prepayment 방식을 통해 Orakl Network와 상호작용할 수 있도록 합니다. Permanent account현재 Request-Response 요청에 대해 권장되는 방법입니다. Prepayment 결제 방식이나 Permanent Account에 대한 자세한 내용은 [Prepayment 사용자 안내서](prepayment.md)를 참조하십시오.

**Temporary Account(임시 계정)** 은 사용자가 추가적인 사전 준비 없이 직접 Request-Response에 대한 지불을 할 수 있도록 합니다. 이 접근 방식은 사용 빈도가 낮거나 **Temporary Account**설정에 신경을 쓰기 원하지 않는 사용자에게 적합합니다.

본 문서에서는 **Permanent Account** 와 **Temporary Account** 두 가지 접근 방식을 설명하며, 마지막으로 [온체인 요청을 생성하는 방법](request-response.md#request) and [API 응답을 후처리하는 방법](request-response.md#response-post-processing)을 설명합니다.

## Permanent Account (recommended)

현재 시점에서는 이미 [`Prepayment` 스마트 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/Prepayment.sol) 을 통해 영구 계정을 생성하고 $KLAY를 예치하고 하나 이상의 consumer를 할당한 상태로 가정하겠습니다. 만약 아직 해당 단계를 완료하지 않으셨다면, 계속 진행하기 위해 [위 해당 단계를 완료하는 방법](prepayment.md)을 읽어보시기 바랍니다.

계정을 생성한 후(`accId`를 얻은 후) 일정량의 $KLAY를 예치하고 하나 이상의 consumer를 할당한 경우, 해당 계정을 사용하여 데이터를 요청하고 응답을 받을 수 있습니다.

- [Initialization](request-response.md#initialization)
- [Get estimated service fee](request-response.md#get-estimated-service-fee)
- [Request data](request-response.md#request-data)
- [Receive response](request-response.md#receive-response)

**Orakl Network Request-Response**를 활용하려는 사용자 스마트 계약은 특정 반환 데이터 유형을 지원하기 위해 추상 이행 계약을 상속해야 합니다. 현재 다음과 같은 유형을 제공합니다:

- `uint128` with `RequestResponseConsumerFulfillUint128`
- `int256` with `RequestResponseConsumerFulfillInt256`
- `bool` with `RequestResponseConsumerFulfillBool`
- `string` with `RequestResponseConsumerFulfillString`
- `bytes32` with `RequestResponseConsumerFulfillBytes32`
- `bytes` with `RequestResponseConsumerFulfillBytes`

위의 모든 유형은 [RequestResponseConsumerFulfill](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/RequestResponseConsumerFulfill.sol) 파일 내에 정의되어 있습니다. 이 튜토리얼에서는 `RequestResponseConsumerFulfillUint128` 만을 사용하여 설명하겠지만, 동일한 원칙은 다른 반환 데이터 유형에도 적용할 수 있습니다.

```solidity
import { RequestResponseConsumerFulfillUint128 } from "@bisonai/orakl-contracts/src/v0.1/RequestResponseConsumerFulfill.sol";

contract RequestResponseConsumer is RequestResponseConsumerFulfillUint128 {
    ...
}
```

### Initialization

Request-Response 스마트 계약 ([`RequestResponseCoordinator`](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/RequestResponseCoordinator.sol)) 은 데이터를 요청하고 수신하는 데 모두 사용됩니다. 배포된 `RequestResponseCoordinator`의 주소는 부모 클래스인 `RequestResponseConsumerBase`의 초기화에 사용됩니다.

```solidity
import { RequestResponseConsumerFulfillUint128 } from "@bisonai/orakl-contracts/src/v0.1/RequestResponseConsumerFulfill.sol";
import { RequestResponseConsumerBase } from "@bisonai/orakl-contracts/src/v0.1/RequestResponseConsumerBase.sol";

contract RequestResponseConsumer is RequestResponseConsumerFulfillUint128 {
  constructor(address coordinator) RequestResponseConsumerBase(coordinator) {
  }
}
```

### Get estimated service fee

`estimateFee` 함수는 제공된 매개변수를 기반으로 요청에 대한 예상 서비스 수수료를 계산합니다.

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

이 함수의 목적과 인수를 이해해 보겠습니다:

- `reqCount`: 이전에 수행된 요청의 수를 나타내는 `uint64` 값입니다. `accId` 를 제공함으로써 [`Prepayment 계약`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/Prepayment.sol#L212-L214)의 `getReqCount()` 외부 함수를 호출하여 `reqCount` 값을 얻을 수 있습니다.
- `numSubmission`: 요청에 대한 제출 횟수를 나타내는 `uint8` 값입니다.
- `callbackGasLimit`: 콜백 함수에 할당된 가스 제한을 나타내는 `uint32` 값입니다

적절한 매개변수로 `estimateFee` 함수를 호출함으로써 사용자는 요청에 필요한 총 수수료의 예상치를 얻을 수 있습니다. 이는 각 요청에 필요한 금액을 지출하는 데 유용할 수 있습니다.

### Request data

데이터 요청(`requestData`)은 [`Prepayment` 스마트 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/Prepayment.sol)의 `addConsumer` 함수를 통해 승인된 계약에서 호출되어야 합니다. 스마트 계약이 승인되지 않은 경우, 요청은 `InvalidConsumer` 오류로 거부됩니다. 계정(`accId`로 지정된)이 존재하지 않거나 충분한 잔액이 없는 경우에도 요청이 거부됩니다.

아래의 예시 코드는 [https://min-api.cryptocompare.com/](https://min-api.cryptocompare.com/) API 서버에서 ETH/USD 가격 정보를 요청하는 코드입니다. 요청에는 데이터를 가져올 위치 ([https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH\&tsyms=USD](https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD)), 와 API 서버로부터의 응답을 어떻게 파싱해야 하는지 (`path` 와 `pow10`)에 대한 정보가 포함됩니다 (아래 목록에 표시된 것은 축약된 버전입니다).응답은 중첩된 JSON 딕셔너리 형태로 제공되며, 먼저 `RAW` 키에 접근한 후, `ETH` 키, `USD` 키, 그리고 마지막으로 `PRICE` 키에 접근하고자 합니다.

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

ETH/USD 가격에 접근한 후, 해당 가격 값이 부동 소수점으로 인코딩되어 있다는 것을 알게 됩니다. 부동 소수점 값을 오프체인에서 온체인으로 간편하게 전환하기 위해, 가격 값을 10의 8승(10e8)으로 곱하고 uint256 데이터 형식으로 값을 유지하기로 결정합니다. 이 최종 값은 오프체인 오라클에 의해 `RequestResponseCoordinator`에 제출되며,이는 결과적으로 consumer 스마트 계약 내에서 `fulfillDataRequest`함수를 호출합니다. 이 페이지의 마지막 섹션에서는 요청을 구성하는 다른 방법과 [오프체인 API 서버로부터 응답을 구문 분석하는 방법](request-response.md#request) 에 대해 자세히 알아보실 수 있습니다.

```solidity
function requestData(
  uint64 accId,
  uint32 callbackGasLimit
)
    public
    onlyOwner
    returns (uint256 requestId)
{
    bytes32 jobId = keccak256(abi.encodePacked("uint128"));
    uint8 numSubmission = 1;
    Orakl.Request memory req = buildRequest(jobId);
    req.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");
    req.add("path", "RAW,ETH,USD,PRICE");
    req.add("pow10", "8");

    requestId = COORDINATOR.requestData(
        req,
        callbackGasLimit,
        accId,
        numSubmission
    );
}
```

아래에는 [`RequestResponseCoordinator` 스마트 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/RequestResponseCoordinator.sol) 에서 정의된 `requestData` 함수와 해당 인수에 대한 설명이 나와 있습니다:

- `req`: 사용자 요청을 포함하는 `Request` 구조체
- `callbackGasLimit`: 확인이 완료된 후에 실행되는 콜백 함수의 가스 한도를 나타내는 `uint32` 값
- `accId`: 요청과 관련된 계정의 ID를 나타내는 `uint64` 값
- `numSubmission`: 오프체인 오라클로부터 요청된 제출 횟수

`COORDINATOR` 계약의 `requestData()` 함수 호출 시 `req`, `accId`, `callbackGasLimit` 그리고 `numSubmission` 을 인수로 전달합니다. 이 함수가 성공적으로 실행되면, 고유한 ID (`requestId`)를 얻게 됩니다. 이후 요청이 이행되면, 여러 요청이 있는 경우 요청과 이행 사이의 매칭을 위해 ID (`requestId`) 가 응답과 함께 제공됩니다.

### Receive response

`fulfillDataRequest` 는 `RequestResponseConsumerFulfillUint128` 추상 스마트 계약의 가상 함수입니다 (각각의 `RequestResponseConsumerFulfill*` 에서 이 함수를 정의합니다). 따라서 이 함수는 오버라이딩되어야 합니다. 이 함수는 요청을 처리할 때 `RequestResponseCoordinator` 에 의해 호출됩니다. 데이터 요청 중에 정의된 `callbackGasLimit` 매개변수는 이 함수의 실행에 필요한 가스 양을 나타냅니다.

```solidity
function fulfillDataRequest(
    uint256 /*requestId*/,
    uint128 response
)
    internal
    override
{
    sResponse = response;
}
```

`fulfillDataRequest` 함수의 인수에 대한 설명은 아래와 같습니다:

- `requestId`: 요청의 ID를 나타내는 `uint256` 값
- `response`: `requestData` 함수를 통해 전송된 데이터 요청을 처리한 후 얻은 `uint128` 값

이 함수는 스마트 계약 초기화 중에 정의된 `RequestResponseCoordinator` 계약에서 실행됩니다. 결과는 저장 변수인 `sResponse`에 저장됩니다.

## Temporary Account

**Temporary Account**는 사용자가 계정을 생성하고 $KLAY를 예치하거나 consumer를 할당하는 과정 없이도 Request-Response 기능을 사용할 수 있는 대체 계정 유형입니다. **Temporary Account**를 사용한 Request-Response는 **Permanent Account**와 비교했을 때 약간 다를 수 있지만, Fulfillment function(이행 함수)는 정확히 동일합니다.

- [Initialization with Temporary Account](request-response.md#initialization-with-temporary-account)
- [Request data with Temporary Account (consumer)](request-response.md#request-data-with-temporary-account-consumer)
- [Cancel request and receive refund (consumer)](request-response.md#cancel-request-and-receive-refund-consumer)
- [Request data with Temporary Account (coordinator)](request-response.md#request-data-with-temporary-account-coordinator)

Orakl Network Request-Response를 활용하려는 사용자 스마트 계약은 다음과 같은 [추상 스마트 계약 중 하나](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/RequestResponseConsumerFulfill.sol)를 상속해야 합니다. 이 추상 스마트 계약들은 우리가 응답으로 예상하는 데이터 유형을 정의합니다.

- `uint128` with `RequestResponseConsumerFulfillUint128`
- `int256` with `RequestResponseConsumerFulfillInt256`
- `bool` with `RequestResponseConsumerFulfillBool`
- `string` with `RequestResponseConsumerFulfillString`
- `bytes32` with `RequestResponseConsumerFulfillBytes32`
- `bytes` with `RequestResponseConsumerFulfillBytes`

```solidity
import { RequestResponseConsumerFulfillUint128 } from "@bisonai/orakl-contracts/src/v0.1/RequestResponseConsumerFulfill.sol";

contract RequestResponseConsumer is RequestResponseConsumerFulfillUint128 {
    ...
}
```

### Initialization with Temporary Account

영구적인 계정이든 임시 계정이든 데이터를 요청하는 Request-Response 소비자 계약을 초기화하는 방법에는 차이가 없습니다.

Request-Response 스마트 계약 ([`RequestResponseCoordinator`](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/RequestResponseCoordinator.sol)) 은 데이터를 요청하고 수신하는 데 모두 사용됩니다. 배포된 `RequestResponseCoordinator`의 주소는 부모 클래스인 `RequestResponseConsumerBase`의 초기화에 사용됩니다.

```solidity
import { RequestResponseConsumerFulfillUint128 } from "@bisonai/orakl-contracts/src/v0.1/RequestResponseConsumerFulfill.sol";
import { RequestResponseConsumerBase } from "@bisonai/orakl-contracts/src/v0.1/RequestResponseConsumerBase.sol";

contract RequestResponseConsumer is RequestResponseConsumerFulfillUint128 {
  constructor(address coordinator) RequestResponseConsumerBase(coordinator) {
  }
}
```

### Request data with Temporary Account (consumer)

**Temporary Account**를 사용한 데이터 요청은 **Permanent Account**를 사용한 요청과 매우 유사합니다. 유일한 차이점은 **Temporary Account**의 경우 사용자가 `value` 속성을 사용하여 호출과 함께 $KLAY를 보내야 하며, **Permanent Account**와 달리 계정 ID (`accId`)를 지정할 필요가 없다는 점입니다. 데이터를 성공적으로 요청하기 위해 여러 가지 확인 사항을 통과해야 합니다. 이에 대한 자세한 내용은 Request data 라는 이전 하위 섹션 중 하나에서 확인하실 수 있습니다.

```solidity
receive() external payable {}

function requestData(
  uint32 callbackGasLimit,
  address refundRecipient
)
    public
    payable
    onlyOwner
    returns (uint256 requestId)
{
    bytes32 jobId = keccak256(abi.encodePacked("uint128"));
    uint8 numSubmission = 1;

    Orakl.Request memory req = buildRequest(jobId);
    req.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");
    req.add("path", "RAW,ETH,USD,PRICE");

    requestId = COORDINATOR.requestData{value: msg.value}(
        req,
        callbackGasLimit,
        numSubmission,
        refundRecipient
    );
}
```

이 함수는 `COORDINATOR` 계약에서 정의된 `requestData()` 함수를 호출하며, `req` , `callbackGasLimit`, `numSubmission` 및 `refundRecipient`를 인수로 전달합니다.서비스에 대한 지불은 `msg.value`를 통해 `COORDINATOR` 계약의 `requestData()로 전송됩니다. 지불이 예상 금액보다 큰 경우 초과된 지불은 `refundRecipient` 주소로 반환됩니다. 최종적으로 데이터 요청이 생성됩니다.

아래 섹션에서는 임시 계정을 사용하여 데이터 요청하는 방법에 대한 보다 자세한 설명을 찾을 수 있습니다.

### Cancel request and receive refund (consumer)

이전 섹션에서는 $KLAY는 데이터 요청과 함께 `RequestResponseCoordinator` 에 전송되고, `RequestResponseCoordinator` 는 $KLAY 예치금을 `Prepayment` 컨트랙트에 전달하는 것을 설명했습니다. 요청이 완료될 때까지 $KLAY 지불액은 `Prepayment` 컨트랙트에 보관됩니다.

드물게도, 요청이 충족되지 못하고 소비자가 원하는 데이터를 받지 못하는 경우가 발생할 수 있습니다. 이러한 경우 예치된 $KLAY를 환불하기 위해서는 먼저 `RequestResponseCoordinator` 내부에서 `cancelRequest` 를 호출하여 요청을 취소한 다음, `Prepayment` 컨트랙트 내의 임시 계정에서 $KLAY (`withdrawTemporary`) 인출해야 합니다. 양쪽 모두에서 소비자 스마트 컨트랙트가 호출자 (`msg.sender`)이어야 합니다. 따라서 소비자 스마트 컨트랙트에 이와 같은 보조 함수를 포함해야 적절한 호출을 수행할 수 있습니다.소비자 컨트랙트에 이러한 함수를 추가하지 않으면 요청을 취소하고 임시 계정에 예치된 자금을 인출하는 것이 불가능하며, 예치된 자금은 영구적으로 `Prepayment` 컨트랙트에 잠긴 채로 남게 됩니다

다음은 소비자 컨트랙트 내에서 요청을 취소하고 임시 계정에서 자금을 인출하는 함수의 예시 코드입니다.

```solidity
function cancelAndWithdraw(
    uint256 requestId,
    uint64 accId,
    address refundRecipient
) external onlyOwner {
    COORDINATOR.cancelRequest(requestId);
    address prepaymentAddress = COORDINATOR.getPrepaymentAddress();
    IPrepayment(prepaymentAddress).withdrawTemporary(accId, payable(refundRecipient));
}
```

### Request data with Temporary Account (coordinator)

다음 함수는 [`RequestResponseCoordinator` 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/RequestResponseCoordinator.sol)에 정의되어 있습니다.

```solidity
function requestData(
    Orakl.Request memory req,
    uint32 callbackGasLimit,
    uint8 numSubmission,
    address refundRecipient
) external payable nonReentrant returns (uint256) {
    uint64 reqCount = 0;
    uint256 fee = estimateFee(reqCount, numSubmission, callbackGasLimit);
    if (msg.value < fee) {
        revert InsufficientPayment(msg.value, fee);
    }

    uint64 accId = sPrepayment.createTemporaryAccount(msg.sender);
    bool isDirectPayment = true;
    uint256 requestId = requestData(
        req,
        accId,
        callbackGasLimit,
        numSubmission,
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

이 함수는 먼저 `estimateDirectPaymentFee()` 함수를 호출하여 요청에 대한 수수료(`fee`)를 계산합니다. `isDirectPayment` 변수는 요청이 **Prepayment** 또는 **Direct Payment** 방법을 통해 생성되었는지 여부를 나타냅니다. 그런 다음 `s_prepayment.deposit(accId)`를 호출하여 요청에 필요한 수수료(`fee`)를 계정에 입금합니다. 입금할 때는 값으로 수수료(`fee`)를 전달합니다. 만약 `msg.value`로 전달된 $KLAY의 금액이 요구되는 수수료(`fee`) 보다 큰 경우, 남은 금액은 `msg.sender.call()` 메서드를 사용하여 호출자에게 반환됩니다. 마지막으로, 함수는 `requestDataInternal()` 함수에 의해 생성된 `requestId`를 반환합니다.

이 함수는 먼저 `estimateFee()` 함수를 호출하여 요청에 대한 수수료를 계산합니다. 그런 다음 `sPrepayment.createTemporaryAccount(msg.sender)` 호출을 사용하여 Prepayment 계약 내에 임시 계정을 생성합니다. 다음으로, `requestData` 함수를 호출하여 데이터를 요청합니다. 함수에는 여러 가지 유효성 검사 단계가 있으므로 필요한 수수료를 계정에 입금하기 전에 데이터 요청을 포함시켰습니다 (`sPrepayment.depositTemporary{value: fee}(accId)`). `requestData` 에 의해 `msg.value` 로 전달되는 $KLAY 금액이 요구되는 수수료보다 큰 경우, 남은 금액은 `refundRecipient` 주소로 반환됩니다. 마지막으로, 함수는 내부 `requestData()` 호출에 의해 생성된 `requestId` 를 반환합니다.

## Request & Response Post-Processing

Orakl Network의 **Orakl Network Request-Response** 솔루션은 소비자가 온체인에서 자체 요청을 정의하고 오프체인 오라클에서 처리한 후 결과를 다시 소비자 스마트 계약으로 보내주는 기능을 제공합니다.

요청은 [Orakl 라이브러리](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/libraries/Orakl.sol)의 도움을 받아 생성됩니다. 각 요청은 job ID와 연관되어 있으며, 어떤 데이터 유형을 리포트할 것인지를 설명합니다. 현재 지원되는 리포트 데이터 유형은 아래 표에서 확인할 수 있습니다.

<table><thead><tr><th width="245">Response Data Type</th><th>Job ID</th></tr></thead><tbody><tr><td><code>uint128</code></td><td><code>keccak256(abi.encodePacked("uint128")</code></td></tr><tr><td><code>int256</code></td><td><code>keccak256(abi.encodePacked("int256")</code></td></tr><tr><td><code>boolean</code></td><td><code>keccak256(abi.encodePacked("boolean")</code></td></tr><tr><td><code>bytes32</code></td><td><code>keccak256(abi.encodePacked("bytes32")</code></td></tr><tr><td><code>bytes</code></td><td><code>keccak256(abi.encodePacked("bytes")</code></td></tr><tr><td><code>string</code></td><td><code>keccak256(abi.encodePacked("string")</code></td></tr></tbody></table>

### Request

작업 식별자는 `Orakl.Request` 데이터 구조를 초기화하는 데 사용됩니다. 요청이 오프체인 오라클에 의해 수신되면, 최종 리포트에 사용할 데이터 유형을 알 수 있습니다.

```solidity
bytes32 jobId = keccak256(abi.encodePacked("uint128"));
Orakl.Request memory req = buildRequest(jobId);
```

`Orakl.Request`의 인스턴스는 소비자의 API 요청과 API 응답의 후처리 방법에 대한 모든 정보를 보유합니다. 요청과 후처리 세부 정보는 `add` 함수를 사용하여 `Orakl.Request`의 인스턴스에 삽입됩니다. `add`함수는 키-값 쌍 매개변수를 받으며, 첫 번째 매개변수는 전달되는 데이터의 유형을 나타내고 두 번째 매개변수는 데이터 자체입니다. 첫 번째 삽입된 키는 `get`이어야 하며, 값은 유효한 API URL이어야 합니다.

```solidity
req.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");
```

> 만약 첫 번째 키가 유효한 API URL 링크로 설정되지 않았다면, 요청은 실패하고 처리되지 않을 것입니다.

### Response Post-Processing

현재 **Orakl Network Request-Response**는 아래 표에 나열된 다섯 가지 다른 후처리 작업을 지원합니다.

<table><thead><tr><th width="171.33333333333331">Operation name</th><th width="346">Explanation</th><th>Example</th></tr></thead><tbody><tr><td><code>path</code></td><td>list of keys for walk through input JSON</td><td><code>req.add("RAW,ETH,USD,PRICE")</code></td></tr><tr><td><code>index</code></td><td>Array index</td><td><code>req.add("index", "2");</code></td></tr><tr><td><code>mul</code></td><td>Multiplication</td><td><code>req.add("mul", "2");</code></td></tr><tr><td><code>div</code></td><td>Division</td><td><code>req.add("div", "2");</code></td></tr><tr><td><code>pow10</code></td><td>Multiplication by</td><td><code>req.add("pow10", "8");</code></td></tr></tbody></table>

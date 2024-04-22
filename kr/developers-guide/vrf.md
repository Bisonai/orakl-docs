---
description: Undeniably random numbers in your smart contract
---

# Verifiable Random Function (VRF)

Orakl Network VRF의 사용 예제에 대한 자세한 내용은 [`vrf-consumer`](https://github.com/Bisonai/vrf-consumer) 예제 리포지토리에서 확인하실 수 있습니다.

## Verifiable Random Function이란?

Verifiable Random Function (VRF)는 입력 데이터 (씨드라고도 불리는)를 기반으로 암호학적으로 무작위 값을 생성하는 함수입니다. 이때 중요한 점은 VRF 출력이 검증 가능하다는 것입니다. VRF 출력과 씨드에 접근할 수 있는 사람은 출력이 올바르게 생성되었는지를 검증할 수 있습니다.

블록체인의 맥락에서 VRF는 예측할 수 없는 무작위성과 편향되지 않은 특성을 제공합니다. 이는 분산 애플리케이션 (dApp)에서 무작위성이 필요한 경우에 유용하게 활용될 수 있습니다. 예를 들어, 무작위 경매나 분산 게임에서 VRF를 사용할 수 있습니다.

Orakl Network VRF는 스마트 계약에서 VRF를 사용하여 검증 가능한 무작위 값을 생성할 수 있도록 지원합니다. Orakl Network VRF는 [prepayment](prepayment.md) 방법을 지원하는 두 가지 다른 계정 유형과 함께 사용할 수 있습니다 :

- [Permanent Account (recommended)](vrf.md#permanent-account-recommended)
- [Temporary Account](vrf.md#temporary-account)

**Permanent Account(영구 계정)** 은 VRF 서비스를 사전에 결제하고, Orakl Network와 상호작용할 때 해당 자금을 사용할 수 있는 계정입니다. 현재 VRF 요청을 위해 권장되는 방법입니다. Prepayment 결제 방법이나 영구 계정에 대한 자세한 내용은 [Prepayment 사용자 안내서](prepayment.md)를 참고해 주시기 바랍니다.

**Temporary Account(임시 계정)** 은 추가적인 사전 준비 없이 VRF에 직접 지불할 수 있는 계정입니다. 이 방법은 가끔 사용하거나 **Temporary Account** 설정에 신경쓰기 싫은 사용자들에게 적합합니다.가능한 빨리 VRF를 사용하고자 할 때 유용합니다.

이 문서의 나머지 부분에서는 VRF를 요청하기 위해 사용할 수 있는 Permanent Account와 Temporary Account 접근 방식에 대해 자세히 설명하고 있습니다.

## Permanent Account (recommended)

이 시점에서 이미 [`Prepayment` 스마트 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/Prepayment.sol) 을 통해 영구 계정을 생성하고 $KLAY를 예치하고 consumer를 할당한 것으로 가정합니다. 아직 해당 단계를 완료하지 않았다면, [위 해당 단계를 완료하는 방법](prepayment.md)에 대해 읽어보시고 이후에 계속 진행해주세요.

계정을 생성하고 (accId를 얻었다고 가정), 일정량의 $KLAY를 예치하고 최소한 하나의 consumer를 할당한 후, 해당 계정을 사용하여 무작위 단어를 요청하고 완료할 수 있습니다.

- [Initialization](vrf.md#initialization)
- [Get estimated service fee](vrf.md#get-estimated-service-fee)
- [Request random words](vrf.md#request-random-words)
- [Fulfill-random words](vrf.md#fulfill-random-words)

Orakl Network VRF를 사용하려는 사용자 스마트 계약은 [`VRFConsumerBase` abstract 추상 스마트 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFConsumerBase.sol)을 상속받아야 합니다.

```solidity
import "@bisonai/orakl-contracts/src/v0.1/VRFConsumerBase.sol";
contract VRFConsumer is VRFConsumerBase {
    ...
}
```

### Initialization

VRF 스마트 계약([`VRFCoordinator`](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFCoordinator.sol)) 은 무작위 단어를 요청하고 request fulfillments(요청 이행)에 모두 사용됩니다. `VRFCoordinator` 주소를 생성자 매개변수로 전달하여 `IVRFCoordinator` 인터페이스와 결합하고, 무작위 단어 요청 (`requestRandomWords`)에 사용하는 것을 권장합니다.

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

`estimateFee` 함수는 제공된 매개변수를 기반으로 랜덤 단어 요청에 대한 예상 서비스 수수료를 계산합니다.

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
- `numSubmission`: 요청에 대한 제출 횟수를 나타내는 `uint8` 값입니다. VRF 요청의 경우 `numSubmission` 값은 항상 `1` 입니다.
- `callbackGasLimit`: 콜백 함수에 할당된 가스 한도를 나타내는 `uint32` 값입니다

적절한 매개변수로 `estimateFee` 함수를 호출함으로써 사용자는 요청에 필요한 총 수수료의 예상치를 얻을 수 있습니다. 이는 각 요청에 필요한 금액을 지출하는 데 유용할 수 있습니다.

### Request random words

Request for random words(무작위 단어 요쳥)은 [`Prepayment` 스마트 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/Prepayment.sol)을 통해 승인된 계약으로부터 호출되어야 합니다. 승인되지 않은 계약으로부터의 요청은 `InvalidConsumer` 오류로 거부됩니다. 또한, 요청된 계정(`accId`) 이 존재하지 않거나 (`InvalidAccount` 오류), 충분한 잔액이 없거나, 등록되지 않은 keyHash를 사용하는 경우 (`InvalidKeyHash` 오류)에도 요청은 거부됩니다.

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

아래에서는 [`VRFCoordinator` 스마트 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFCoordinator.sol)에서 정의된 `requestRandomWords` 함수와 해당 인수에 대한 설명을 확인하실 수 있습니다:

- `keyHash`: 무작위 단어를 생성하는 데 사용되는 키의 해시를 나타내는 bytes32 값으로, 신뢰할 수 있는 VRF 제공자를 선택하는 데에도 사용됩니다.
- `accId`: 요청과 관련된 계정의 ID를 나타내는 `uint64` 값입니다.
- `callbackGasLimit`: 컨펌이 수신된 후 실행되는 콜백 함수의 가스 한도를 나타내는 `uint32` 값입니다.
- `numWords`: 요청된 무작위 단어의 수를 나타내는 `uint32` 값입니다. (최대 500)

`COORDINATOR` 계약에서 `requestRandomWords()`함수를 호출할 때, `keyHash`, `accId`, `callbackGasLimit`, 그리고 `numWords` 를 인수로 전달합니다. 이 함수가 성공적으로 실행된 후, 고유한 ID(`requestId`)를 얻게 됩니다. 이후, 요청이 완료되면, ID (`requestId`)는 여러 개의 요청이 있는 경우 요청과 완료 사이의 대응을 할 수 있도록 무작위 단어와 함께 제공됩니다.

### Fulfill random words

`fulfillRandomWords` 는 [`VRFConsumerBase` 스마트 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFConsumerBase.sol)의 가상 함수로,오버라이딩되어야 합니다. 이 함수는 `VRFCoordinator`가 요청을 이행할 때 호출됩니다. VRF 요청 중에 정의된 `callbackGasLimit` 매개변수는 이 함수의 실행에 필요한 가스 한도를 나타냅니다.

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

`fulfillRandomWords` 함수의 인수에 대한 설명은 아래와 같습니다:

- `requestId`: 요청의 ID를 나타내는 `uint256` 값
- `randomWords`: 요청에 대한 응답으로 생성된 `uint256` 값들의 배열

이 함수는 이전에 정의된 `COORDINATOR` 계약으로부터 실행됩니다. `uint256` 데이터 형식의 범위 내에서 받은 무작위 값들(`randomWords`) 중 첫 번째 무작위 요소를 선택하고, 그 값을 1부터 50 사이의 범위로 제한하여 저장합니다. 결과는 변수 `s_randomResult`에 저장됩니다.

## Temporary Account

**Temporary Account(임시 계정)** 은 사용자가 VRF 기능을 사용하기 위해 계정을 생성하고, $KLAY를 예치하고, consumer를 할당할 필요가 없는 대체 계정 유형입니다. Request for VRF with **Temporary Account** 로 VRF를 요청하는 방법은 **Permanent Account**와 약간 다르지만, 완료 함수는 완전히 동일합니다.

- [Initialization with Temporary Account](vrf.md#initialization-with-temporary-account)
- [Request random words with Temporary Account (consumer)](vrf.md#request-random-words-with-temporary-account-consumer)
- [Cancel request and receive refund (consumer)](vrf.md#cancel-request-and-receive-refund-consumer)
- [Request random words with Temporary Account (coordinator)](vrf.md#request-random-words-with-temporary-account-coordinator)

Orakl Network VRF를 사용하려는 사용자 스마트 계약은 [`VRFConsumerBase` 추상 스마트 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFConsumerBase.sol)을 상속해야 합니다.

```solidity
import "@bisonai/orakl-contracts/src/v0.1/VRFConsumerBase.sol";
contract VRFConsumer is VRFConsumerBase {
    ...
}
```

### Initialization With Temporary Account

**Temporary Account**를 사용하여 VRF를 요청하는 VRF 사용자 계약의 초기화 과정은 **Permanent Account**를 사용하는 경우와 동일합니다.

VRF 스마트 계약 ([`VRFCoordinator`](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFCoordinator.sol))는 무작위 단어를 요청하는데 사용되며, 요청 완료에도 사용됩니다. `VRFCoordinator` 주소를 생성자 매개변수로 전달하여 `IVRFCoordinator` 인터페이스와 연결하고, random words requests(무작위 단어 요청) (`requestRandomWords`)에 사용하는 것을 권장합니다.

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

**Temporary Account**를 용하여 무작위 단어를 요청하는 과정은 **Permanent Account**를 사용하는 경우와 매우 유사합니다. 유일한 차이점은 **Temporary Account**를 사용하는 경우 호출과 함께 값 속성을 통해 $KLAY를 전송해야 한다는 점입니다. VRF를 성공적으로 요청하기 위해 몇 가지 확인 사항을 통과해야 합니다. **Request random words** 라는 이전 제목에서 자세히 알아볼 수 있습니다.

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

이 함수는 `COORDINATOR` 계약에 정의된 `requestRandomWords()` 함수를 호출하며, `keyHash`, `callbackGasLimit`, `numWords` 및 `refundRecipient`를 인수로 전달합니다. 서비스에 대한 지불은 `msg.value`를 통해 `COORDINATOR` 계약의 `requestRandomWords()` 함수로 전송됩니다. 지불 금액이 예상 지불보다 큰 경우 초과 지불액은 `refundRecipient` 주소로 반환됩니다. 이를 통해 무작위 단어 요청이 생성됩니다. requestRandomWords 함수에 대한 msg.value를 정확하게 지정하려면, [`서비스 수수료를 추정`](vrf.md#get-estimated-service-fee)하는 방법에 대한 설명을 참조해주세요.

아래 섹션에서는 임시 계정을 사용하여 무작위 단어를 요청하는 방법에 대한 더 자세한 설명을 확인하실 수 있습니다.

### Cancel request and receive refund (consumer)

이전 섹션에서 설명한 대로, VRF 요청과 함께 $KLAY가 `VRFCoordinator` 에게 전송되고, `VRFCoordinator` 는 이를 `Prepayment` 컨트랙트로 전달합니다. $KLAY 지불은 요청이 이행될 때까지 `Prepayment` 컨트랙트에 보관됩니다.

드물게도 요청이 이행되지 않을 수 있으며, 소비자는 요청한 난수를 받지 못할 수도 있습니다. 이러한 경우 예치된 $KLAY를 환불받으려면, 먼저 `VRFCoordinator` 내부에서 `cancelRequest` 를 호출하여 요청을 취소하고, 그런 다음 `Prepayment` 컨트랙트 내의 임시 계정에서 $KLAY (`withdrawTemporary`) 를 인출해야 합니다. 두 경우 모두, 소비자 스마트 컨트랙트가 호출자 (`msg.sender`)여야 합니다. 따라서 소비자 스마트 컨트랙트에 이와 같은 보조 함수를 포함해야 적절한 호출을 수행할 수 있습니다. 소비자 컨트랙트에 이러한 함수를 추가하지 않으면 요청을 취소하고 임시 계정에 예치된 자금을 인출하는 것이 불가능하며, 예치된 자금은 영구적으로 `Prepayment` 컨트랙트에 잠긴 채로 남게 됩니다

다음은 소비자 컨트랙트 내에서 요청을 취소하고 임시 계정에서 자금을 인출하는 함수의 예시 코드입니다.

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

다음 함수는 [`VRFCoordinator` 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/VRFCoordinator.sol)에 정의되어 있습니다.

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

해당 함수는 먼저 `estimateFee()` 함수를 호출하여 요청에 필요한 수수료를 계산합니다. 그런 다음, `sPrepayment.createTemporaryAccount(msg.sender)` 호출을 통해 Prepayment 계약 내에서 임시 계정을 생성합니다. 다음 단계에서는 `requestRandomWords` 함수를 사용하여 무작위 단어 요청을 진행합니다. 이 함수에는 여러 유효성 검사 단계가 있으며, 수수료를 입금하기 전에 무작위 단어를 요청하는 과정을 포함시켰습니다 (`sPrepayment.depositTemporary{value: fee}(accId)`). 만약 `msg.value`로 전달된 $KLAY 금액이 요구되는 수수료보다 크다면, 남은 금액은 `refundRecipient` 주소로 반환됩니다. 마지막으로, 함수는 내부적으로 호출된 `requestRandomWords()`에 의해 생성된 `requestId`를 반환합니다.

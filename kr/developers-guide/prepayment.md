# Prepayment

## What is Prepayment?

**Prepayment** 는 임시 계정 **임시 계정(Temporary Account)** 과 **영구 계정(Permanent Account)** 두 가지 계정 유형을 지원하는 결제 솔루션입니다. 이는 [`Prepayment` 스마트 계약](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/Prepayment.sol) 내에 구현되어 있으며 현재 Verifiable Random Function (VRF) 및 Request-Response 서비스에 대한 결제로 사용될 수 있습니다.

**Temporary Account** 는 일회용 계정으로, 이 유형의 계정을 활용하는 요청마다 새롭게 생성됩니다. 임시 계정을 활용하는 것이 조금 더 간편하므로 초기 테스트에 적합한 방법입니다. 해당 요청과 관련된 생명주기 동안만 계정이 존재하며, 요청이 완료되면 계정이 삭제됩니다.

**Permanent Account** 는 더 많은 기능을 제공하며, 이 문서의 나머지 부분에서 이에 대해 자세히 알아보겠습니다. **영구 계정** 의 주요 구성 요소는 **계정(Account)** , **계정 소유자(Account Owner)** 그리고 **컨슈머(Consumer)** 입니다.

- **Account owners** 는 계정을 생성할 수 있는 주체입니다 (`createAccount`). 또한 계정을 종료할 수 있으며 (`cancelAccount`), 계정에서 소비자를 추가 (`addConsumer`) 하거나 제거 (`removeConsumer`) 할 수 있습니다. $KLAY는 계정 소유자만이 인출할 수 있지만 누구나 어떤 계정에든지 $KLAY를 입금할 수 있습니다 (`deposit`).
- 계정에 할당된 **Consumers** 는 Orakl Network 서비스를 결제하기 위해 해당 계정의 잔액을 사용합니다. 계정의 소유권은 (`requestAccountOwnerTransfer`, `acceptAccountOwnerTransfer`) 라는 두 단계의 과정을 통해 다른 주체로 이전될 수 있습니다. 코디네이터는 컨슈머들이 발행한 요청을 충족시킬 수 있는 스마트 컨트랙트로, 요청을 충족시킨 오라클들에게 보상을 분배합니다.

## How to use Prepayment?

**Permanent Account** 는 스마트 컨트랙트 인터페이스 또는 [Orakl Network 계정 페이지](https://www.orakl.network/account)의 웹 프론트엔드를 통해 제어할 수 있습니다. 이 페이지에서는 스마트 컨트랙트를 통해서만 영구적인 계정에 접근하고 제어하는 방법을 설명합니다.

Orakl Network 서비스를 결제하기 위해 **Permanent Account** 를 사용하기 전에 수행해야 할 [사전 준비 사항](prepayment.md#prerequisites)이 있습니다. 기본적인 사전 준비 사항에 익숙하다면, Prepayment 스마트 컨트랙트에 정의된 [다른 보조 기능](prepayment.md#other-functions)에도 관심이 있을 수 있습니다.

### Prerequisites

1. [Create account](prepayment.md#create-account)
2. [Deposit $KLAY to account](prepayment.md#deposit-usdklay-to-account)
3. [Add consumer](prepayment.md#add-consumer)

#### **Create account**

```solidity
function createAccount() external returns (uint64) {
    uint64 currentAccId = sCurrentAccId + 1;
    sCurrentAccId = currentAccId;

    Account acc = new Account(currentAccId, msg.sender);
    sAccIdToAccount[currentAccId] = acc;

    emit AccountCreated(currentAccId, address(acc), msg.sender);
    return currentAccId;
}
```

이 함수는 전역 변수 `sCurrentAccId` 를 1씩 증가시켜 로컬 변수 `currentAccId` 에 저장하고, `Account` 스마트 컨트랙트를 배포하여 새로 생성된 주소를 계정 ID와 계정 컨트랙트 주소를 매핑하는 맵에 저장합니다. Account 컨트랙트는 계정 소유자에 대한 정보를 저장하고 초기 잔액을 0으로 설정하며 등록된 소비자 스마트 컨트랙트가 없습니다. 새로 생성된 계정 ID와 송신자의 주소에 대한 정보는 `AccountCreated` 이벤트를 통해 발행됩니다. 마지막으로 새로운 계정 ID를 반환합니다.

#### **Deposit $KLAY to account**

```solidity
function deposit(uint64 accId) external payable {
    Account account = sAccIdToAccount[accId];
    if (address(account) == address(0)) {
        revert InvalidAccount();
    }
    uint256 amount = msg.value;
    uint256 balance = account.getBalance();

    (bool sent, ) = payable(account).call{value: msg.value}("");
    if (!sent) {
        revert FailedToDeposit();
    }

    emit AccountBalanceIncreased(accId, balance, balance + amount);
}
```

이 함수는 계정 ID (`accId`)와 관련된 계정 컨트랙트의 주소를 검색합니다. 해당하는 계정 컨트랙트가 없는 경우 함수는 되돌려집니다 (`InvalidAccount`). 전달받은 $KLAY는 계정 컨트랙트로 전송됩니다. 마지막으로, 입금 전후의 계정 잔액은 `AccountBalanceIncreased` 이벤트를 통해 발행됩니다.

#### **Add consumer**

```solidity
function addConsumer(uint64 accId, address consumer) external onlyAccountOwner(accId) {
    sAccIdToAccount[accId].addConsumer(consumer);
    emit AccountConsumerAdded(accId, consumer);
}
```

이 함수는 계정 ID (`accId`)와 연관된 계정 컨트랙트에 대한 외부 호출을 수행합니다. 새로운 consumer는 (`consumer`)매개변수로 정의되며, 아직 등록되지 않은 경우에만 추가됩니다. 마지막으로, `AccountConsumerAdded` 이벤트를 인자로 계정 ID와 소비자 주소를 발생시킵니다.

### Other functions

`Prepayment` 스마트 계약은 많은 다른 보조 함수를 지원합니다. 이 문서에서는 그 중 일부를 설명합니다:

- Transfer account ownership
- Accept account ownership
- Remove consumer
- Cancel account
- Withdraw funds from account

#### **Transfer account ownership**

```solidity
function requestAccountOwnerTransfer(
    uint64 accId,
    address requestedOwner
) external onlyAccountOwner(accId) {
    sAccIdToAccount[accId].requestAccountOwnerTransfer(requestedOwner);
    emit AccountOwnerTransferRequested(accId, msg.sender, requestedOwner);
}
```

이 함수는 계정 ID (`accId`)와 연관된 계정 소유자로부터 `요청받은 소유자`로의 계정 소유권 이전을 요청합니다. `AccountOwnerTransferRequested` 는 계정의 소유권 이전 요청이 있음을 나타냅니다.

#### **Accept account ownership**

```solidity
function acceptAccountOwnerTransfer(uint64 accId) external {
    Account account = sAccIdToAccount[accId];
    address newOwner = msg.sender;
    address oldOwner = account.getOwner();
    account.acceptAccountOwnerTransfer(newOwner);
    emit AccountOwnerTransferred(accId, oldOwner, newOwner);
}
```

이 함수는 이전에 요청된 `requestedOwner`로의 계정 소유권 이전을 최종적으로 완료합니다. 이 함수는 `요청받은 소유자`만 실행할 수 있으며, 그렇지 않을 경우 되돌립니다. `AccountOwnerTransferred` 는 해당 계정에 대한 소유권 이전이 완료되었음을 나타냅니다.

#### **Remove consumer**

```solidity
function removeConsumer(uint64 accId, address consumer) external onlyAccountOwner(accId) {
    sAccIdToAccount[accId].removeConsumer(consumer);
    emit AccountConsumerRemoved(accId, consumer);
}
```

이 함수는 계정 ID (`accId`)로 지정된 계정 스마트 컨트랙트에 대한 외부 호출을 수행합니다. 호출 내에서 등록된 `consumer` 의 주소가 consumers 집합에서 제거됩니다. 최종적으로, `AccountConsumerRemoved` 이벤트를 발생시켜 계정 ID와 소비자 주소를 인수로 전달합니다.

#### **Cancel account**

```solidity
function cancelAccount(uint64 accId, address to) external onlyAccountOwner(accId) {
    if (pendingRequestExists(accId)) {
        revert PendingRequestExists();
    }

    Account account = sAccIdToAccount[accId];
    uint256 balance = account.getBalance();
    delete sAccIdToAccount[accId];

    account.cancelAccount(to);

    emit AccountCanceled(accId, to, balance);
}
```

이 함수는 `pendingRequestExists(accId)` 함수를 호출하여 해당 계정에 대기 중인 요청이 있는지 확인합니다. 대기 중인 요청이 있는 경우, 함수는 `PendingRequestExists()`오류 메시지와 함께 되돌려집니다. 대기 중인 요청이 없는 경우, 계정 ID (`accId`)로 지정된 계정 스마트 컨트랙트에 대한 `cancelAccount`외부 호출을 수행합니다. 이 호출은 컨트랙트를 파괴하고, 매개변수로 지정된 주소 (`to`)로 남은 모든 $KLAY를 전송합니다.

#### **Withdraw funds from account**

```solidity
function withdraw(uint64 accId, uint256 amount) external onlyAccOwner(accId) {
    if (pendingRequestExists(accId)) {
        revert PendingRequestExists();
    }

    uint256 oldBalance = s_accounts[accId].balance;
    if ((oldBalance < amount) || (address(this).balance < amount)) {
        revert InsufficientBalance();
    }

    s_accounts[accId].balance -= amount;

    (bool sent, ) = msg.sender.call{value: amount}("");
    if (!sent) {
        revert InsufficientBalance();
    }

    emit AccountBalanceDecreased(accId, oldBalance, oldBalance - amount);
}

function withdraw(uint64 accId, uint256 amount) external onlyAccountOwner(accId) {
    if (pendingRequestExists(accId)) {
        revert PendingRequestExists();
    }

    (bool sent, uint256 balance) = sAccIdToAccount[accId].withdraw(amount);
    if (!sent) {
        revert FailedToWithdraw(accId);
    }

    emit AccountBalanceDecreased(accId, balance + amount, balance);
}
```

이 함수는 계정의 잔액에서 지정된 `금액`을 차감하고, 외부 호출을 통해 차감된 금액을 계정 소유자에게 이체합니다. 마지막으로, 계정 ID, 이전 잔액, 새로운 잔액을 인수로 하는 `AccountBalanceDecreased` 이벤트를 발생시킵니다. `AccountBalanceDecreased` 이벤트는 인출이 완료되었음을 나타냅니다.

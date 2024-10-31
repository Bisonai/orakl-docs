# Prepayment

## What is Prepayment?

**Prepayment** is a type of payment solution with a support for two account types: **Temporary Account** and **Permanent Account**. It is implemented within a [`Prepayment` smart contract](https://github.com/Bisonai-CIC/orakl/blob/master/contracts/src/v0.1/Prepayment.sol) and currently it can be used as a payment for Verifiable Random Function (VRF) and Request-Response services.

**Temporary Account** is an account for one-time-use, and it is newly created with every request that takes advantage of this type of account. It is a bit easier to utilize temporary account, therefore it is a good way for initial tests. The account exists only during the lifetime of the associated request and once the request is fulfilled, the account is deleted.

**Permanent Account** offers more features and in the rest of the document we will dive into them. The main components of **Permanent Account** are **Account**, **Account Owner** and **Consumer.**

- **Account owners** are entities that create an account (`createAccount`). They can also close the account (`cancelAccount`), add (`addConsumer`) or remove consumer (`removeConsumer`) from their account(s). $KAIA can be withdrawn from account only by the account owner, however anybody is allowed to deposit (`deposit`) $KAIA to any account.
- **Consumers** assigned to account use the account's balance to pay for Orakl Network services. The ownership of account can be transferred to other entity through a two-step process (`requestAccountOwnerTransfer`, `acceptAccountOwnerTransfer`). Coordinators are smart contracts that can fulfill request issued by consumers, and they distribute rewards to oracles that fulfill requests.

## How to use Permanent Account?

**Permanent Account** can be controlled either controlled through a smart contract interface, or through a web frontend on our [Orakl Network Account page](https://www.orakl.network/account). In this page, we describe how you can access and control permanent account through smart contracts only.

There are [prerequisites](prepayment.md#prerequisites) that you have to do before you can use your **Permanent Account** to pay for Orakl Network services. If you are already experienced with the basic prerequisites, you might be interested in[ other auxiliary functions](prepayment.md#other-functions) defined on Prepayment smart contract.

### Prerequisites

1. [Create account](prepayment.md#create-account)
2. [Deposit $KAIA to account](prepayment.md#deposit-kaia-to-account)
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

This function creates a new account by incrementing a global variable `sCurrentAccId` by 1 and storing the value in a local variable `currentAccId`. Then, it deploys an `Account` smart contract and stores its newly generated address to mapping from account ID to account contract address. Account contracts stores information about owner of the account, sets initial balance to zero, and have no registered consumer smart contracts. Information about newly created account ID and sender's address are emitted using `AccountCreated` event. Finally, it returns the new account ID.

#### **Deposit $KAIA to account**

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

This function retrieves the address of account contract associated with account ID (`accId`). If there is no such account contract, function is reverted (`InvalidAccount`). Received $KAIA are send to account contract. Finally, account balance before and after deposit is emitted through `AccountBalanceIncreased` event.

#### **Add consumer**

```solidity
function addConsumer(uint64 accId, address consumer) external onlyAccountOwner(accId) {
    sAccIdToAccount[accId].addConsumer(consumer);
    emit AccountConsumerAdded(accId, consumer);
}
```

This function makes external call to account contract associated with account ID (`accId`). New consumer is defined as a parameter (`consumer`) and it is added only in case it has not been registered yet. Finally, it emits an event `AccountConsumerAdded` with the account ID and consumer address as arguments.

### Other functions

`Prepayment` smart contract supports many other auxiliary functions. In this document, we describe some of them:

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

This function requests transfer of account ownership from owner of account associated with account ID (`accId`) to `requestedOwner`. `AccountOwnerTransferRequested` indicates that a request for owner transfer has been made for the account.

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

This function finalizes the transfer of account ownership to the previously proposed `requestedOwner`. This function can be executed only by the `requestedOwner`, otherwise it reverts. `AccountOwnerTransferred` indicates that the transfer of ownership has been completed for the account.

#### **Remove consumer**

```solidity
function removeConsumer(uint64 accId, address consumer) external onlyAccountOwner(accId) {
    sAccIdToAccount[accId].removeConsumer(consumer);
    emit AccountConsumerRemoved(accId, consumer);
}
```

This function makes an external call to account smart contract specified by account ID (`accId`). Within the call, address of `consumer` is removed from the set of registered consumers. Eventually, it emits an event `AccountConsumerRemoved` with the account ID and consumer address as arguments.

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

This function checks if there are any pending requests for the account by calling a function `pendingRequestExists(accId)`. If there are any pending requests, the function reverts with the error message `PendingRequestExists()`. If there are no pending requests, we make an external call `cancelAccount` on account contract specified by account ID (`accId`). This call destroys the contract and send all remaining $KAIA to address (`to`) specified as parameter.

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

This function subtracts the `amount` from the account's balance and transfers the withdrawn amount to the owner of the account using the external call. Finally, it emits an event `AccountBalanceDecreased` with the account ID, old balance and new balance as arguments. `AccountBalanceDecreased` event indicates that the withdrawal has been completed.

#### Other Account types for Fiat and Kaia Subsription

We also have some other account types, which can only be created and updated by our operators. These account types are for fiat (or KAIA) subscription plan.

```solidity
    function createFiatSubscriptionAccount(
        uint256 startDate,
        uint256 period,
        uint256 reqPeriodCount,
        address accOwner
    ) external onlyOwner returns (uint64) {
        uint64 currentAccId = sCurrentAccId + 1;
        sCurrentAccId = currentAccId;

        Account acc = new Account(currentAccId, accOwner, IAccount.AccountType.FIAT_SUBSCRIPTION);
        sAccIdToAccount[currentAccId] = acc;

        acc.updateAccountDetail(startDate, period, reqPeriodCount, 0);

        emit AccountCreated(
            currentAccId,
            address(acc),
            accOwner,
            IAccount.AccountType.FIAT_SUBSCRIPTION
        );
        return currentAccId;
    }
```

```solidity
    function createKlaySubscriptionAccount(
        uint256 startDate,
        uint256 period,
        uint256 reqPeriodCount,
        uint256 subscriptionPrice,
        address accOwner
    ) external onlyOwner returns (uint64) {
        uint64 currentAccId = sCurrentAccId + 1;
        sCurrentAccId = currentAccId;

        Account acc = new Account(currentAccId, accOwner, IAccount.AccountType.KLAY_SUBSCRIPTION);
        sAccIdToAccount[currentAccId] = acc;
        acc.updateAccountDetail(startDate, period, reqPeriodCount, subscriptionPrice);
        emit AccountCreated(
            currentAccId,
            address(acc),
            accOwner,
            IAccount.AccountType.KLAY_SUBSCRIPTION
        );
        return currentAccId;
    }
```

```solidity
   function createKlayDiscountAccount(
        uint256 feeRatio,
        address accOwner
    ) external onlyOwner returns (uint64) {
        uint64 currentAccId = sCurrentAccId + 1;
        sCurrentAccId = currentAccId;
        Account acc = new Account(currentAccId, accOwner, IAccount.AccountType.KLAY_DISCOUNT);
        sAccIdToAccount[currentAccId] = acc;
        acc.setFeeRatio(feeRatio);
        emit AccountCreated(
            currentAccId,
            address(acc),
            accOwner,
            IAccount.AccountType.KLAY_DISCOUNT
        );
        return currentAccId;
    }
```

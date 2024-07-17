---
description: Registering and Using Oracle Network Services on L2 Chains
---

# L2 Services

- [Registry Contract](l2-services.md#registry-contract)
- [Endpoint Contracts](l2-services.md#endpoint-contracts)
- [How to Integrate VRF and Request-Response on L2](l2-services.md#how-to-integrate-vrf-and-request-response-on-l2)

## Registry Contract

This contract allows you to manage new chain and Orakl Network services.

### L2 Chain Management

> Please contact [Orakl Network](mailto:business@orakl.network) after you propose a new chain. We will support you to set things up.

1. Propose New Chain and Pay `proposeFee`

```solidity
function proposeNewChain(
    uint256 _chainID,
    string memory _jsonRpc,
    address _endpoint
) external payable {
    if (msg.value < proposeFee) {
        revert NotEnoughFee();
    }
    if (chainRegistry[_chainID].owner != address(0)) {
        revert ChainExisted();
    }
    pendingProposal[_chainID].jsonRpc = _jsonRpc;
    pendingProposal[_chainID].endpoint = _endpoint;
    pendingProposal[_chainID].owner = msg.sender;
    emit ChainProposed(msg.sender, _chainID);
}
```

2. Edit Chain Info

```solidity
function editChainInfo(
    uint256 _chainID,
    string memory _jsonRpc,
    address _endpoint
) external payable onlyConfirmedChainOwner(_chainID) {
    if (msg.value < proposeFee) {
        revert NotEnoughFee();
    }

    chainRegistry[_chainID].jsonRpc = _jsonRpc;
    chainRegistry[_chainID].endpoint = _endpoint;
    emit ChainEdited(_jsonRpc, _endpoint);
}
```

### Account and Payment Functions

Before you can make a request from L2 chain, you need to create and deposit to your account.

1. Create Account

```solidity
function createAccount(uint256 _chainId) external onlyConfirmedChain(_chainId) {
    Account storage newAccount = accounts[nextAccountId];
    newAccount.accId = nextAccountId;
    newAccount.chainId = _chainId;
    newAccount.owner = msg.sender;
    newAccount.balance = 0;
    emit AccountCreated(nextAccountId, _chainId, msg.sender);
    nextAccountId++;
}
```

2. Deposit Funds Into the Account

```solidity
function deposit(uint256 _accId) public payable {
    accounts[_accId].balance += msg.value;
    emit BalanceIncreased(_accId, msg.value);
}
```

3. Add Consumer Into Account

```solidity
function addConsumer(
    uint256 _accId,
    address _consumerAddress
) external onlyAccountOwner(_accId) {
    Account storage account = accounts[_accId];
    require(account.consumerCount < MAX_CONSUMER, "Max consumers reached");

    account.consumers.push(_consumerAddress);
    account.consumerCount++;

    emit ConsumerAdded(_accId, _consumerAddress);
}
```

4. Remove Consumer From Account

```solidity
function removeConsumer(
    uint256 _accId,
    address _consumerAddress
) external onlyAccountOwner(_accId) {
    require(_accId > 0 && _accId < nextAccountId, "Account does not exist");
    Account storage account = accounts[_accId];

    for (uint8 i = 0; i < account.consumerCount; i++) {
        address[] storage consumers = account.consumers;
        if (consumers[i] == _consumerAddress) {
            account.consumerCount--;
            consumers[i] = consumers[account.consumerCount];
            consumers.pop();
            emit ConsumerRemoved(_accId, _consumerAddress);
            return;
        }
    }
}
```

> The consumer address to add or remove to this account is on L2 chain, not mainnet.

## Endpoint Contracts

### `L2Endpoint`

You need to deploy this contract on your chain; it acts as a coordinator for VRF and Request-Response.

1. Request Random Words From L2

```solidity
function requestRandomWords(
    bytes32 keyHash,
    uint64 accId,
    uint32 callbackGasLimit,
    uint32 numWords
) external nonReentrant returns (uint256) {
    sNonce++;
    (uint256 requestId, uint256 preSeed) = computeRequestId(keyHash, msg.sender, accId, sNonce);
    sRequestDetail[requestId] = RequestInfo({
        owner: msg.sender,
        callbackGasLimit: callbackGasLimit
    });
    emit RandomWordsRequested(
        keyHash,
        requestId,
        preSeed,
        accId,
        callbackGasLimit,
        numWords,
        msg.sender
    );

    return requestId;
}
```

2. Request Data From L2

```solidity
function requestData(
    Orakl.Request memory req,
    uint32 callbackGasLimit,
    uint64 accId,
    uint8 numSubmission
) external nonReentrant returns (uint256) {
    sNonce++;
    uint256 requestId = computeRequestId(msg.sender, accId, sNonce);
    sRequestDetail[requestId] = RequestInfo({
        owner: msg.sender,
        callbackGasLimit: callbackGasLimit
    });
    emit DataRequested(
        requestId,
        req.id,
        accId,
        callbackGasLimit,
        msg.sender,
        numSubmission,
        req
    );

    return requestId;
}
```

## How to Integrate VRF and Request-Response on L2

- [VRF](l2-services.md#vrf)
- [Request-Response](l2-services.md#request-response)

### VRF

> Refer to [L2 VRF mock consumer contract](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/mocks/L2VRFConsumerMock.sol).

1. Inherit from the `VRFConsumerBase` Contract

```solidity
contract L2VRFConsumerMock is VRFConsumerBase
```

2. Specify `l2Endpoint` in the Constructor

```solidity
constructor(address l2Endpoint) VRFConsumerBase(l2Endpoint) {
    sOwner = msg.sender;
    L2ENDPOINT = IL2Endpoint(l2Endpoint);
}
```

3. Implement the `requestRandomWords` Function

```solidity
 function requestRandomWords(
    bytes32 keyHash,
    uint64 accId,
    uint32 callbackGasLimit,
    uint32 numWords
) public onlyOwner returns (uint256 requestId) {
    requestId = L2ENDPOINT.requestRandomWords(keyHash, accId, callbackGasLimit, numWords);
}
```

4. Implement the `fulfillRandomWords` Function

```solidity
function fulfillRandomWords(
    uint256 /* requestId */,
    uint256[] memory randomWords
) internal override {
    sRandomWord = (randomWords[0] % 50) + 1;
}
```

### Request-Response

> Refer to [L2 Request-Response mock consumer contract](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/mocks/L2RequestResponseConsumerMock.sol).

1. Inherit from the Base Contract for Request Data Types

```solidity
contract L2RequestResponseConsumerMock is
    RequestResponseConsumerFulfillUint128,
    RequestResponseConsumerFulfillInt256,
    RequestResponseConsumerFulfillBool,
    RequestResponseConsumerFulfillString,
    RequestResponseConsumerFulfillBytes32,
    RequestResponseConsumerFulfillBytes
```

2. Specify `l2Endpoint` in the Constructor

```solidity
constructor(address l2Endpoint) RequestResponseConsumerBase(l2Endpoint) {
    sOwner = msg.sender;
    L2ENDPOINT = IL2Endpoint(l2Endpoint);
}
```

3. Implement `requestData*` Function

```solidity
//request for uint128
function requestDataUint128(
    uint64 accId,
    uint32 callbackGasLimit,
    uint8 numSubmission
) public onlyOwner returns (uint256 requestId) {
    bytes32 jobId = keccak256(abi.encodePacked("uint128"));
    Orakl.Request memory req = buildRequest(jobId);
    //change here for your expected data
    req.add(
        "get",
        "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=KLAY&tsyms=USD"
    );
    req.add("path", "RAW,KLAY,USD,PRICE");
    req.add("pow10", "8");
    requestId = L2ENDPOINT.requestData(req, callbackGasLimit, accId, numSubmission);
}
```

4. Implement the `fulfillDataRequest` Function

```solidity
function fulfillDataRequest(uint256 /*requestId*/, uint128 response) internal override {
    sResponseUint128 = response;
}
```

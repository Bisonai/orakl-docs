---
description: L2체인에서 오라클 서비스를 등록하고 사용하는 방법
---

# L2 서비스

- [Registry 컨트랙트](l2-services.md#registry-contract)
- [Endpoint 컨트랙트](l2-services.md#endpoint-contracts)
- [L2에서 데이터 피드, VRF, RR사용하는 방법](l2-services.md#how-to-integrate-data-feed-vrf-and-request-response-on-l2)

## Registry 컨트랙트

이 컨트랙트를 통해 체인과 오라클서비스를 관리할 수 있습니다.

### L2 Chain 관리

> 신규체인을 제안 해주신 뒤 [오라클 네트워크](mailto:business@orakl.network)로 연락주세요. 환경 세팅을 지원해드립니다.

1. 신규 체인을 제안하고 `proposeFee`를 지불하세요

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

2. 체인 정보를 수정하세요

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

### L2 데이터 피드 관리

1. 데이터 피드 추가하기

```solidity
function addAggregator(
    uint256 chainID,
    address l1Aggregator,
    address l2Aggregator
) external onlyConfirmedChainOwner(chainID) {
    AggregatorPair memory newAggregatorPair = AggregatorPair({
        aggregatorID: aggregatorCount[chainID]++,
        l1Aggregator: l1Aggregator,
        l2Aggregator: l2Aggregator
    });
    aggregators[chainID].push(newAggregatorPair);
    emit AggregatorAdded(chainID, newAggregatorPair.aggregatorID);
}
```

2. 데이터 피드 제거하기

```solidity
function removeAggregator(
    uint256 chainID,
    uint256 aggregatorID
) external onlyConfirmedChainOwner(chainID) {
    AggregatorPair[] storage aggregatorInfo = aggregators[chainID];
    for (uint256 i = 0; i < aggregatorInfo.length; i++) {
        if (aggregatorInfo[i].aggregatorID == aggregatorID) {
            // Move the last item to the current index to be removed
            aggregatorInfo[i] = aggregatorInfo[aggregatorInfo.length - 1];

            // Remove the last item from the list
            aggregatorInfo.pop();

            emit AggregatorRemoved(chainID, aggregatorID);
            break; // Exit the loop once item is found and removed
        }
    }
}
```

### 계정과 지불 기능

L2 체인에서 요청을 하기 전에, 계정을 만들고 입금해야합니다.

1. 계정 생성

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

2. 계정에 입금하기

```solidity
function deposit(uint256 _accId) public payable {
    accounts[_accId].balance += msg.value;
    emit BalanceIncreased(_accId, msg.value);
}
```

3. 계정에 Consumer 추가하기

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

4. 계정에서 Consumer 제거하기

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

> 이 account에 추가되거나 제거되는 consumer는 메인넷이 아니라 L2 chain에 있어야 합니다

## 엔드포인트 Contracts

### `L2Endpoint`

체인에 이 컨트랙트가 배포되어야 합니다. 이것은 VRF와 Request-Response의 coordinator로서 작동합니다.

1. L2 데이터 피드 추가하기

```solidity
function addAggregator(address _newAggregator) external onlyOwner {
    if (sAggregators[_newAggregator]) revert InvalidAggregator(_newAggregator);
    sAggregators[_newAggregator] = true;
    sAggregatorCount += 1;
    emit AggregatorAdded(_newAggregator);
}
```

2. L2 데이터 피드 제거하기

```solidity
function removeAggregator(address _aggregator) external onlyOwner {
    if (!sAggregators[_aggregator]) revert InvalidAggregator(_aggregator);
    delete sAggregators[_aggregator];
    sAggregatorCount -= 1;
    emit AggregatorRemoved(_aggregator);
}
```

3. L2 데이터 피드 리포터 추가하기

```solidity
function addSubmitter(address _newSubmitter) external onlyOwner {
    if (sSubmitters[_newSubmitter]) revert InvalidSubmitter(_newSubmitter);
    sSubmitters[_newSubmitter] = true;
    sSubmitterCount += 1;
    emit SubmitterAdded(_newSubmitter);
}
```

4. L2 데이터 피드 리포터 제거하기

```solidity
function removeSubmitter(address _submitter) external onlyOwner {
        if (!sSubmitters[_submitter]) revert InvalidSubmitter(_submitter);
        delete sSubmitters[_submitter];
        sSubmitterCount -= 1;
        emit SubmitterRemoved(_submitter);
    }
```

5. L2애서 random words 요청하기

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

6. L2에서 데이터 요청하기

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

## L2에서 데이터피드, VRF, RR 사용하기

- [Data Feed](l2-services.md#data-feed)
- [VRF](l2-services.md#vrf)
- [Request-Response](l2-services.md#request-response)

### 데이터피드

L2에서는 `Aggregator`와 `AggregatorProxy` 컨트랙트가 메인넷과 동일하게 사용됩니다. [Data Feed consumer contract](https://github.com/Bisonai/data-feed-consumer)를 참고하여주세요.

### VRF

> [L2 VRF mock consumer contract](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/mocks/L2VRFConsumerMock.sol)를 참고해주세요.

1. `VRFConsumerBase` 컨트랙트를 상속받습니다

```solidity
contract L2VRFConsumerMock is VRFConsumerBase
```

2. Constructor에서 `l2Endpoint`를 지정해주세요

```solidity
constructor(address l2Endpoint) VRFConsumerBase(l2Endpoint) {
    sOwner = msg.sender;
    L2ENDPOINT = IL2Endpoint(l2Endpoint);
}
```

3. `requestRandomWords` function을 구현해주세요

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

4. `fulfillRandomWords` function을 구현해주세요

```solidity
function fulfillRandomWords(
    uint256 /* requestId */,
    uint256[] memory randomWords
) internal override {
    sRandomWord = (randomWords[0] % 50) + 1;
}
```

### Request-Response

> [L2 Request-Response mock consumer contract](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/mocks/L2RequestResponseConsumerMock.sol)를 참고해주세요.

1. 요청 데이터 타입에 따라 컨트랙트를 상속해주세요

```solidity
contract L2RequestResponseConsumerMock is
    RequestResponseConsumerFulfillUint128,
    RequestResponseConsumerFulfillInt256,
    RequestResponseConsumerFulfillBool,
    RequestResponseConsumerFulfillString,
    RequestResponseConsumerFulfillBytes32,
    RequestResponseConsumerFulfillBytes
```

2. Constructor에서 `l2Endpoint`를 지정해주세요

```solidity
constructor(address l2Endpoint) RequestResponseConsumerBase(l2Endpoint) {
    sOwner = msg.sender;
    L2ENDPOINT = IL2Endpoint(l2Endpoint);
}
```

3. `requestData*` Function을 구현해주세요

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

4. `fulfillDataRequest` Function을 구현해주세요

```solidity
function fulfillDataRequest(uint256 /*requestId*/, uint128 response) internal override {
    sResponseUint128 = response;
}
```

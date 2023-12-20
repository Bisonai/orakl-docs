---
description: How to integrate and use Orakl network on other networks
---

## Registry contract on Klaytn
This contracts allows you to manage new chain and services for Orakl network
# Manage new chains:
1. propsose a new chain and pay for propose fee:

```
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
2. Edit chain Info after it is confirmed
```
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
**information** Please contact us after you propose a new chain. We will support you to set things up
# define datafeeds to relay from source datafeeds on Klaytn
1. Add Datafeeds
```
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
2. Remove Datafeeds
```
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
# Account and payment functions
You need to create an account, and fund it with Klay before you can make a request from another chain

1. Create an account
```
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
2. deposit fund into the acount
```
function deposit(uint256 _accId) public payable {
        accounts[_accId].balance += msg.value;
        emit BalanceIncreased(_accId, msg.value);
    }
```
3. add consumers to an account
```    function addConsumer(
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
4. Remove consumer from an account
```
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
**information**The consumer address to add or remove to this account is on your chain, not Klaytn

## Endpoint contracts
# L2endpoint
You need to deploy this contract on you chain, this act as a coordinatior for VRF and RR
1. add, remove L2 datafeeds
```
function addAggregator(address _newAggregator) external onlyOwner {
        if (sAggregators[_newAggregator]) revert InvalidAggregator(_newAggregator);
        sAggregators[_newAggregator] = true;
        sAggregatorCount += 1;
        emit AggregatorAdded(_newAggregator);
    }
```
```
function removeAggregator(address _aggregator) external onlyOwner {
        if (!sAggregators[_aggregator]) revert InvalidAggregator(_aggregator);
        delete sAggregators[_aggregator];
        sAggregatorCount -= 1;
        emit AggregatorRemoved(_aggregator);
    }
```
2. add remove reporter for L2 datafeeds
```
function addSubmitter(address _newSubmitter) external onlyOwner {
        if (sSubmitters[_newSubmitter]) revert InvalidSubmitter(_newSubmitter);
        sSubmitters[_newSubmitter] = true;
        sSubmitterCount += 1;
        emit SubmitterAdded(_newSubmitter);
    }
```

```
function removeSubmitter(address _submitter) external onlyOwner {
        if (!sSubmitters[_submitter]) revert InvalidSubmitter(_submitter);
        delete sSubmitters[_submitter];
        sSubmitterCount -= 1;
        emit SubmitterRemoved(_submitter);
    }

```
3. Coordinator functions for VRF and RR
```
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
```
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







---
description: Continuous stream of off-chain data to your smart contract
---

# Data Feed

A detailed example of how to use Orakl Network Data Feed can be found at example repository [`data-feed-consumer`](https://github.com/Bisonai/data-feed-consumer).

## What is Data Feed?

The Orakl Network Data Feed is a secure, reliable, and decentralized source of off-chain data accessible to smart contracts on-chain. The data feed is updated at predefined time intervals, as well as if the data value deviates more than a predefined threshold, to ensure that the data remains accurate and up-to-date. Data feeds can be used in many different on-chain protocols:

* Lending and borrowing
* Mirrored assets
* Stablecoins
* Asset management
* Options and futures
* and many more!

The Orakl Data Feed includes various data feeds that can be used free of charge. The currently supported data feeds can be found in the table below.

### Supported Data Feeds

| Data Feed  | Aggregator                                                                                                                      | AggregatorProxy                                                                                                                 | Heartbeat (ms) |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| BTC-USDT   | [0x640Ed61e261C545D7439bDBb27e1674a6F589e96](https://baobab.klaytnfinder.io/account/0x640Ed61e261C545D7439bDBb27e1674a6F589e96) | [0x6492009c469373972710744eD34725D96D8c07B3](https://baobab.klaytnfinder.io/account/0x6492009c469373972710744eD34725D96D8c07B3) | 15,000         |
| ETH-USDT   | [0x9C2248d7EafB3D9e9D615E52965bD387a12c856b](https://baobab.klaytnfinder.io/account/0x9C2248d7EafB3D9e9D615E52965bD387a12c856b) | [0xFD91E50218a5451a88D7C83Ed7b555F20aa216f2](https://baobab.klaytnfinder.io/account/0xFD91E50218a5451a88D7C83Ed7b555F20aa216f2) | 15,000         |
| KLAY-USDT  | [0x80139B55D6539E08890b93448B1A93cd014Ed87C](https://baobab.klaytnfinder.io/account/0x80139B55D6539E08890b93448B1A93cd014Ed87C) | [0x1BFf2A4B141a18532A141Ec079FbAb615bba907f](https://baobab.klaytnfinder.io/account/0x1BFf2A4B141a18532A141Ec079FbAb615bba907f) | 15,000         |
| MATIC-USDT | [0x99E9E1a78498575E78F46675b54847767C5787Fb](https://baobab.klaytnfinder.io/account/0x99E9E1a78498575E78F46675b54847767C5787Fb) | [0xCe0BBfA49C0b82B9768DFB8d1f1efC907a496842](https://baobab.klaytnfinder.io/account/0xCe0BBfA49C0b82B9768DFB8d1f1efC907a496842) | 15,000         |
| SOL-USDT   | [0x56BbC261dE7529a2D9F89B75734A86ac5f9e3008](https://baobab.klaytnfinder.io/account/0x56BbC261dE7529a2D9F89B75734A86ac5f9e3008) | [0x900350a321c12Ad5388DE96087FdCF90f7ec319B](https://baobab.klaytnfinder.io/account/0x900350a321c12Ad5388DE96087FdCF90f7ec319B) | 15,000         |
| USDC-USDT  | [0x08e2425CE1fa5f8EB006d3898C48C5d3de44B795](https://baobab.klaytnfinder.io/account/0x08e2425CE1fa5f8EB006d3898C48C5d3de44B795) | [0xFd5fb8a27ADd2Faa62Ef3c5f0EA78AEAbE1E07A3](https://baobab.klaytnfinder.io/account/0xFd5fb8a27ADd2Faa62Ef3c5f0EA78AEAbE1E07A3) | 15,000         |
| DAI-USDT   | [0xe17D821E9A8A8736B9AEA8C2DE1f3A4934ac0A2F](https://baobab.klaytnfinder.io/account/0xe17D821E9A8A8736B9AEA8C2DE1f3A4934ac0A2F) | [0xC0B2da601400c9dd49D8eF29E47a16a47932331e](https://baobab.klaytnfinder.io/account/0xC0B2da601400c9dd49D8eF29E47a16a47932331e) | 15,000         |
| DOT-USDT   | [0x4a11035D511E8094E483761Db1b9c834d55b1894](https://baobab.klaytnfinder.io/account/0x4a11035D511E8094E483761Db1b9c834d55b1894) | [0xeD2c791eae84a9845f7832110c9Cd7E1D9670235](https://baobab.klaytnfinder.io/account/0xeD2c791eae84a9845f7832110c9Cd7E1D9670235) | 15,000         |
| BNB-USDT   | [0x4D92F10A23E28AB11d2d39325B9db0Fd0504520d](https://baobab.klaytnfinder.io/account/0x4D92F10A23E28AB11d2d39325B9db0Fd0504520d) | [0x694b6591bA06Ea48b9A07dB78B93cCdF5d144f38](https://baobab.klaytnfinder.io/account/0x694b6591bA06Ea48b9A07dB78B93cCdF5d144f38) | 15,000         |
| TRX-USDT   | [0x50365C346BAd261a29ADd3Be7bA18B6c49E4f4Cf](https://baobab.klaytnfinder.io/account/0x50365C346BAd261a29ADd3Be7bA18B6c49E4f4Cf) | [0x9ED2D63D6af73b416E0a47B56899ddE8435d89a6](https://baobab.klaytnfinder.io/account/0x9ED2D63D6af73b416E0a47B56899ddE8435d89a6) | 15,000         |
| BUSD-USDT  | [0xA3ca19bAE3dC93521Ff0a9A7DC78713e8bB55D0c](https://baobab.klaytnfinder.io/account/0xA3ca19bAE3dC93521Ff0a9A7DC78713e8bB55D0c) | [0x88DaE047193444aba53B316f40961528c326080d](https://baobab.klaytnfinder.io/account/0x88DaE047193444aba53B316f40961528c326080d) | 15,000         |
| MNR-KRW    | [0x89CAddB33969797d008b64D3adB4E45D7d829D68](https://baobab.klaytnfinder.io/account/0x89CAddB33969797d008b64D3adB4E45D7d829D68) | [0xe9656248a3148f4cfed909fe4c79b386c9b2d595](https://baobab.klaytnfinder.io/account/0xe9656248A3148f4cfed909fE4c79B386c9b2d595) | 15,000         |

## Architecture

The on-chain implementation of Data Feed is composed of two smart contracts: [`Aggregator`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/Aggregator.sol) and [`AggregatorProxy`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/AggregatorProxy.sol). At first,`Aggregator` and `AggregatorProxy` are deployed together in pair, representing a single data feed (e.g. temperature in Seoul or price of BTC/USD). `Aggregator` is being updated at regular intervals by off-chain oracles, and `AggregatorProxy` is used to access the submitted data to `Aggregator`. Deployed `AggregatorProxy` contract represents a consistent API to read data from the feed, and `Aggregator` contract can be replaced with a newer version.

In the rest of the page, we will focus on [how to read from data feed](data-feed.md#how-to-read-from-data-feed) and [explain relation between `Aggregator` and `AggregatorProxy`](data-feed.md#relation-between-aggregatorproxy-and-aggregator).

## How to read from data feed?

In this section, we will explain how to integrate Orakl Network data feed to your smart contract to be able to read from any data feed. We will also point out potential issues you might encounter and how to solve them.

The section is split into following topics:

* [Initialization](data-feed.md#initialization)
* [Read Data](data-feed.md#read-data)
* [Process Data](data-feed.md#process-data)

### Initialization

The access to data feed is provided through the `AggregatorProxy` address corresponding to a data feed of your choice, and [`AggregatorInterface`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/interfaces/AggregatorInterface.sol) from [`@bisonai/orakl-contracts`](https://www.npmjs.com/package/@bisonai/orakl-contracts).

```solidity
import {AggregatorInterface} from "@bisonai/orakl-contracts/src/v0.1/interfaces/AggregatorInterface.sol";
contract DataFeedConsumer {
    AggregatorInterface internal dataFeed;
    constructor(address aggregatorProxy) {
        dataFeed = AggregatorInterface(aggregatorProxy);
    }
}
```

### Read Data

Data can be queried from feed using following functions: `latestRoundData()` and `getRoundData(roundId)`.

The `latestRoundData` function returns metadata about the latest submission.

```solidity
(
   uint80 id,
    int256 answer,
    uint startedAt,
    uint updatedAt,
    uint80 answeredInRound
) = dataFeed.latestRoundData();
```

Submissions are divided into rounds and indexed by an `id`. Node operators are expected to report submission in every round, and aggregate is computed from all submissions in the same round. Submissions from previous rounds can be queried through `getRoundData` function which requires a single extra parameter `roundId`. The output format is same as from `latestRoundData` function.

```solidity
uint80 roundId = 
(
    uint80 id,
    int256 answer,
    uint startedAt,
    uint updatedAt,
    uint80 answeredInRound
) = dataFeed.getRoundData(roundId);
```

### Process Data

The values returned from `latestRoundData()` and `getRoundData(roundId)` functions do not include only the data feed value (=`answer`) at corresponding round `id` but also others:

* `startedAt`
* `updatedAt`
* `answeredInRound`

`startedAt` represents the timestamp when the round was started. `updatedAt` represents the timestamp when the round was updated last time. `answeredInRound` is the round `id` in which the answer was computed.

> We highly recommend you to keep track of all metadata returned by both `latestRoundData()` and `getRoundData(roundId)`. If your application is dependent on frequent updates, you have to make sure in application layer that data returned by any of these functions is not stale.

`AggregatorProxy` has several other auxiliary functions that should be utilized in order to avoid any issues from misrepresenting the `answer` returned from data feed.

All `answer`s are returned with a specific decimal precision that can be queried using `decimals()` function.

```solidity
uint8 decimals = dataFeed.decimals();
```

`AggregatorProxy` is always connected to a single `Aggregator`, but this connection is not fixed and `Aggregator` can be changed. If you want to make sure that you are still using the same `Aggregator` you can ask for the `Aggregator` address through `aggregator()` function.

```solidity
address currentAggregator = dataFeed.aggregator()
```

## Relation between `AggregatorProxy` and `Aggregator`

When deploying an`AggregatorProxy` , `Aggregator`'s address has to be specified to create a connection between contracts. Consumer can then requests data through `latestRoundData` or `getRoundData` functions, and data will be fetched from `Aggregator` that is represented by the `aggregatorAddress`.

```solidity
constructor(address aggregatorAddress) {
    setAggregator(aggregatorAddress);
}
```

At times, it might be necessary to update the address of `Aggregator.` If the `Aggregator` address is updated, a queried data feed will come from a different `Aggregator` than before the update. `AggregatorProxy`'s update of `Aggregator` is split into two steps: proposal and confirmation. Both steps can be only executed with `onlyOwner` privileges.

`proposeAggregator` stores the proposed address to storage variable and emits event about new address being proposed.

```solidity
 function proposeAggregator(address aggregatorAddress) external onlyOwner {
     s_proposedAggregator = AggregatorProxyInterface(aggregatorAddress);
     emit AggregatorProposed(address(s_currentPhase.aggregator), aggregatorAddress);
 }
```

After the new `Aggregator` is proposed, one can query a new data feed through a special functions: `proposedLatestRoundData` and `proposedGetRoundData`. These functions are useful for testing a new data feed, before accepting the new proposed `Aggregator`.

The function `confirmAggregator` is used to finalize the transition to a new proposed `Aggregator`, and can be executed only with account that has `onlyOwner` privilege. New aggregator is finalized through `setAggregator` (called also inside of `constructor` of `AggregatorProxy`). Finally, the new aggregator is announced through emitted event.

```solidity
function confirmAggregator(address aggregatorAddress) external onlyOwner {
    require(aggregatorAddress == address(s_proposedAggregator), "Invalid proposed aggregator");
    address previousAggregator = address(s_currentPhase.aggregator);
    delete s_proposedAggregator;
    setAggregator(aggregatorAddress);
    emit AggregatorConfirmed(previousAggregator, aggregatorAddress);
}
```

---
description: Continuous stream of off-chain data to your smart contract
---

# Data Feed

A detailed example of how to use **Orakl Network Data Feed** can be found at example repository [`data-feed-consumer`](https://github.com/Bisonai/data-feed-consumer).

## What is Data Feed?

The Orakl Network Data Feed is a secure, reliable, and decentralized source of off-chain data accessible to smart contracts on-chain. The data feed is updated at predefined time intervals, as well as if the data value deviates more than a predefined threshold, to ensure that the data remains accurate and up-to-date. Data feeds can be used in many different on-chain protocols:

* Lending and borrowing
* Mirrored assets
* Stablecoins
* Asset management
* Options and futures
* and many more!

The Orakl Data Feed includes various data feeds that can be used free of charge. The currently supported data feeds can be found in the table below.

### Supported Data Feeds on Baobab

| Data Feed  | Aggregator                                                                                                                      | AggregatorProxy                                                                                                                 | Heartbeat (ms) |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| BTC-USDT   | [0xE747418f2fe0F5794c5105f718b59b283E1B5e07](https://baobab.klaytnfinder.io/account/0xE747418f2fe0F5794c5105f718b59b283E1B5e07) | [0x4b0687ce6eC3Fe6c019467c744D0C563643BdFa4](https://baobab.klaytnfinder.io/account/0x4b0687ce6eC3Fe6c019467c744D0C563643BdFa4) | 15,000         |
| ETH-USDT   | [0xf1AF997ffA9b43CcA41078d74C3F897DB998e9bd](https://baobab.klaytnfinder.io/account/0xf1AF997ffA9b43CcA41078d74C3F897DB998e9bd) | [0xAEc43Fc8D4684b6A6577c3B18A1c1c6d3D55C28E](https://baobab.klaytnfinder.io/account/0xAEc43Fc8D4684b6A6577c3B18A1c1c6d3D55C28E) | 15,000         |
| KLAY-USDT  | [0xf0d6Ccdd18B8A7108b901af872021109C27095bA](https://baobab.klaytnfinder.io/account/0xf0d6Ccdd18B8A7108b901af872021109C27095bA) | [0xC874f389A3F49C5331490145f77c4eFE202d72E1](https://baobab.klaytnfinder.io/account/0xC874f389A3F49C5331490145f77c4eFE202d72E1) | 15,000         |
| MATIC-USDT | [0x7970d00F24e65F1BC757896e32Db820A8e9260F0](https://baobab.klaytnfinder.io/account/0x7970d00F24e65F1BC757896e32Db820A8e9260F0) | [0x311Ec6D3a9db944aE0e92B083F1dbDe0cECcAA1C](https://baobab.klaytnfinder.io/account/0x311Ec6D3a9db944aE0e92B083F1dbDe0cECcAA1C) | 15,000         |
| SOL-USDT   | [0xBd01EdC16597f68E03607ba4b941596729ec78f7](https://baobab.klaytnfinder.io/account/0xBd01EdC16597f68E03607ba4b941596729ec78f7) | [0x3C39209e85c1a27f1B992Bcf3416f5fC84764F2e](https://baobab.klaytnfinder.io/account/0x3C39209e85c1a27f1B992Bcf3416f5fC84764F2e) | 15,000         |
| USDC-USDT  | [0x49e47b1149149CAEc5384427E41A387Bbc17698c](https://baobab.klaytnfinder.io/account/0x49e47b1149149CAEc5384427E41A387Bbc17698c) | [0xd46Ca83fdC20641ce2e225E930FBfb8CE8334660](https://baobab.klaytnfinder.io/account/0xd46Ca83fdC20641ce2e225E930FBfb8CE8334660) | 15,000         |
| DAI-USDT   | [0x219BAD3A896964A2B28Ef4dE6Ae6E6D72B646745](https://baobab.klaytnfinder.io/account/0x219BAD3A896964A2B28Ef4dE6Ae6E6D72B646745) | [0xdE2aA055F8DA4d2a4A5063b8736C8455AEa8aB3F](https://baobab.klaytnfinder.io/account/0xdE2aA055F8DA4d2a4A5063b8736C8455AEa8aB3F) | 15,000         |
| DOT-USDT   | [0x2b062807C6B3F8Ca5C366545d50aA19c114E9d7b](https://baobab.klaytnfinder.io/account/0x2b062807C6B3F8Ca5C366545d50aA19c114E9d7b) | [0x7dc55064b6ea6B75F8A73DC142707aAd0A37541c](https://baobab.klaytnfinder.io/account/0x7dc55064b6ea6B75F8A73DC142707aAd0A37541c) | 15,000         |
| BNB-USDT   | [0x731A5AFB6e021579138Ea469B25C2ab46ff44199](https://baobab.klaytnfinder.io/account/0x731A5AFB6e021579138Ea469B25C2ab46ff44199) | [0xFA4CfAD7DBB1a0b3e85d0b736cf00289edDDDd5F](https://baobab.klaytnfinder.io/account/0xFA4CfAD7DBB1a0b3e85d0b736cf00289edDDDd5F) | 15,000         |
| TRX-USDT   | [0xb4de9C81eaA329E1E7161E9a235D795E29eec60D](https://baobab.klaytnfinder.io/account/0xb4de9C81eaA329E1E7161E9a235D795E29eec60D) | [0x37c7Aac954e721eaBA28c58BeF496529Cde32d5f](https://baobab.klaytnfinder.io/account/0x37c7Aac954e721eaBA28c58BeF496529Cde32d5f) | 15,000         |
| BUSD-USDT  | [0xc820F6E9ab1A9321d22720A0986088A9298563ed](https://baobab.klaytnfinder.io/account/0xc820F6E9ab1A9321d22720A0986088A9298563ed) | [0x6727E828CCa9b5cB639e740d5A275Cd7CdB0b647](https://baobab.klaytnfinder.io/account/0x6727E828CCa9b5cB639e740d5A275Cd7CdB0b647) | 15,000         |
| MNR-KRW    | [0x22ddDb9749cB5941DdEc5fD50B12CfDdB8E259c9](https://baobab.klaytnfinder.io/account/0x22ddDb9749cB5941DdEc5fD50B12CfDdB8E259c9) | [0x6DEbE43FD00D3Dcc93D8695a3031fC8887242dee](https://baobab.klaytnfinder.io/account/0x6DEbE43FD00D3Dcc93D8695a3031fC8887242dee) | 15,000         |

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

The access to data feed is provided through the `AggregatorProxy` address corresponding to a data feed of your choice, and [`IAggregator`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/interfaces/IAggregator.sol) from [`@bisonai/orakl-contracts`](https://www.npmjs.com/package/@bisonai/orakl-contracts).

```solidity
import { IAggregator } from "@bisonai/orakl-contracts/src/v0.1/interfaces/IAggregator.sol";

contract DataFeedConsumer {
    IAggregator internal dataFeed;
    constructor(address aggregatorProxy) {
        dataFeed = IAggregator(aggregatorProxy);
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

When deploying an`AggregatorProxy` , `Aggregator`'s address has to be specified to create a connection between the contracts. Consumer can then request data through `latestRoundData` or `getRoundData` functions, and data will be fetched from `Aggregator` that is represented by the `aggregatorAddress`.

```solidity
constructor(address aggregatorAddress) {
    setAggregator(aggregatorAddress);
}
```

At times, it might be necessary to update the address of `Aggregator.` If the `Aggregator` address is updated, a queried data feed will come from a different `Aggregator` than before the update. `AggregatorProxy`'s update of `Aggregator` is split into two steps: proposal and confirmation. Both steps can be only executed with `onlyOwner` privileges.

`proposeAggregator` stores the proposed address to storage variable and emits event about new address being proposed.

```solidity
 function proposeAggregator(address aggregatorAddress) external onlyOwner {
     sProposedAggregator = AggregatorProxyInterface(aggregatorAddress);
     emit AggregatorProposed(address(sCurrentPhase.aggregator), aggregatorAddress);
 }
```

After the new `Aggregator` is proposed, one can query a new data feed through a special functions: `proposedLatestRoundData` and `proposedGetRoundData`. These functions are useful for testing a new data feed, before accepting the new proposed `Aggregator`.

The function `confirmAggregator` is used to finalize the transition to the new proposed `Aggregator`, and can be executed only with account that has `onlyOwner` privilege. New aggregator is finalized through `setAggregator` (called also inside of `constructor` of `AggregatorProxy`). Finally, the new aggregator is announced through emitted event.

```solidity
function confirmAggregator(address aggregatorAddress) external onlyOwner {
    require(aggregatorAddress == address(sProposedAggregator), "Invalid proposed aggregator");
    address previousAggregator = address(sCurrentPhase.aggregator);
    delete sProposedAggregator;
    setAggregator(aggregatorAddress);
    emit AggregatorConfirmed(previousAggregator, aggregatorAddress);
}
```

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

The Orakl Data Feed includes various data feeds that can be used free of charge. The currently supported data feeds can be found in tables below.

### Supported Data Feeds on Cypress

<table><thead><tr><th width="157">Data Feed</th><th>Aggregator</th><th>AggregatorProxy</th><th>Heartbeat (ms)</th></tr></thead><tbody><tr><td>BTC-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x21df0fDC25cd276FAec7a081159788a2Ec52e040">0x21df0fdc25cd276faec7a081159788a2ec52e040</a></td><td><a href="https://www.klaytnfinder.io/account/0xc0516486DD0837a8Dd6E502F9134Ff3c421377AC">0xc0516486dd0837a8dd6e502f9134ff3c421377ac</a></td><td>15,000</td></tr><tr><td>ETH-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x0ee317740EA515D02587393AA32CbB6686110CAE">0x0ee317740ea515d02587393aa32cbb6686110cae</a></td><td><a href="https://www.klaytnfinder.io/account/0x37C637922D6F5F62e067588A75E9d59c26cd64c3">0x37c637922d6f5f62e067588a75e9d59c26cd64c3</a></td><td>15,000</td></tr><tr><td>KLAY-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x955bd135ABBc0eB0D022556602112A9Ec456d41d">0x955bd135abbc0eb0d022556602112a9ec456d41d</a></td><td><a href="https://www.klaytnfinder.io/account/0x33D6ee12D4ADE244100F09b280e159659fe0ACE0">0x33d6ee12d4ade244100f09b280e159659fe0ace0</a></td><td>15,000</td></tr><tr><td>MATIC-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x40E97db6E366eF067020A0d98FB3E427299397ba">0x40e97db6e366ef067020a0d98fb3e427299397ba</a></td><td><a href="https://www.klaytnfinder.io/account/0xC51B1ec2e0a88c7156Af634cB46F83525F00F784">0xc51b1ec2e0a88c7156af634cb46f83525f00f784</a></td><td>15,000</td></tr><tr><td>SOL-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x7ec03AC011101eC050df4eEB9e3383608D81fcC1">0x7ec03ac011101ec050df4eeb9e3383608d81fcc1</a></td><td><a href="https://www.klaytnfinder.io/account/0x09B387816847AB0702aFb4e4FfA43240dcA20Bc6">0x09b387816847ab0702afb4e4ffa43240dca20bc6</a></td><td>15,000</td></tr><tr><td>USDC-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x138eAA152f9702076cEA9CB420Fa763049d44251">0x138eaa152f9702076cea9cb420fa763049d44251</a></td><td><a href="https://www.klaytnfinder.io/account/0x0Eb4cA5f008080191a7780101118b5a26e9925E4">0x0eb4ca5f008080191a7780101118b5a26e9925e4</a></td><td>15,000</td></tr><tr><td>DAI-USDT</td><td><a href="https://www.klaytnfinder.io/account/0xc20fA4a7Ba95Ec7E4CbB9458403365210EFa09B5">0xc20fa4a7ba95ec7e4cbb9458403365210efa09b5</a></td><td><a href="https://www.klaytnfinder.io/account/0xC12f7c66b3F192b074Ff883803bAb7571bd6a25D">0xc12f7c66b3f192b074ff883803bab7571bd6a25d</a></td><td>15,000</td></tr><tr><td>DOT-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x38362F1a2d7c223a132018505A35a87A63f7840A">0x38362f1a2d7c223a132018505a35a87a63f7840a</a></td><td><a href="https://www.klaytnfinder.io/account/0x90708e35E62dea8024dE3672Ca05a4626D5d5e9C">0x90708e35e62dea8024de3672ca05a4626d5d5e9c</a></td><td>15,000</td></tr><tr><td>BNB-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x47c63Bca3Fa9D3eA7F9Bc7C48C14f691d50FB872">0x47c63bca3fa9d3ea7f9bc7c48c14f691d50fb872</a></td><td><a href="https://www.klaytnfinder.io/account/0x7aa7bD1A2AD16527293200a4Fecc9548b2822A59">0x7aa7bd1a2ad16527293200a4fecc9548b2822a59</a></td><td>15,000</td></tr><tr><td>TRX-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x035A27A2797106Dc68606cA054dA5429750F0d86">0x035a27a2797106dc68606ca054da5429750f0d86</a></td><td><a href="https://www.klaytnfinder.io/account/0x28A69574604E01c86C116Fe4C6EdE28CDbe66b4B">0x28a69574604e01c86c116fe4c6ede28cdbe66b4b</a></td><td>15,000</td></tr><tr><td>BUSD-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x0655f5196Bd589632a1fd7f15d73382537ACCEe5">0x0655f5196bd589632a1fd7f15d73382537accee5</a></td><td><a href="https://www.klaytnfinder.io/account/0x31e438B3d2b838a30A0c02460cd1E6B7a6ED5B60">0x31e438b3d2b838a30a0c02460cd1e6b7a6ed5b60</a></td><td>15,000</td></tr><tr><td>MNR-KRW</td><td><a href="https://www.klaytnfinder.io/account/0xfccB3925817e0dCFEE28343769Bbe203D8443a98">0xfccb3925817e0dcfee28343769bbe203d8443a98</a></td><td><a href="https://www.klaytnfinder.io/account/0x61be615807fC5306E1C691D290a422aF7995B4C5">0x61be615807fc5306e1c691d290a422af7995b4c5</a></td><td>15,000</td></tr></tbody></table>

### Supported Data Feeds on Baobab

<table><thead><tr><th width="159">Data Feed</th><th width="218">Aggregator</th><th width="255">AggregatorProxy</th><th>Heartbeat (ms)</th></tr></thead><tbody><tr><td>BTC-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xE747418f2fe0F5794c5105f718b59b283E1B5e07">0xE747418f2fe0F5794c5105f718b59b283E1B5e07</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x4b0687ce6eC3Fe6c019467c744D0C563643BdFa4">0x4b0687ce6eC3Fe6c019467c744D0C563643BdFa4</a></td><td>15,000</td></tr><tr><td>ETH-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xf1AF997ffA9b43CcA41078d74C3F897DB998e9bd">0xf1AF997ffA9b43CcA41078d74C3F897DB998e9bd</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xAEc43Fc8D4684b6A6577c3B18A1c1c6d3D55C28E">0xAEc43Fc8D4684b6A6577c3B18A1c1c6d3D55C28E</a></td><td>15,000</td></tr><tr><td>KLAY-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xf0d6Ccdd18B8A7108b901af872021109C27095bA">0xf0d6Ccdd18B8A7108b901af872021109C27095bA</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xC874f389A3F49C5331490145f77c4eFE202d72E1">0xC874f389A3F49C5331490145f77c4eFE202d72E1</a></td><td>15,000</td></tr><tr><td>MATIC-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x7970d00F24e65F1BC757896e32Db820A8e9260F0">0x7970d00F24e65F1BC757896e32Db820A8e9260F0</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x311Ec6D3a9db944aE0e92B083F1dbDe0cECcAA1C">0x311Ec6D3a9db944aE0e92B083F1dbDe0cECcAA1C</a></td><td>15,000</td></tr><tr><td>SOL-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xBd01EdC16597f68E03607ba4b941596729ec78f7">0xBd01EdC16597f68E03607ba4b941596729ec78f7</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x3C39209e85c1a27f1B992Bcf3416f5fC84764F2e">0x3C39209e85c1a27f1B992Bcf3416f5fC84764F2e</a></td><td>15,000</td></tr><tr><td>USDC-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x49e47b1149149CAEc5384427E41A387Bbc17698c">0x49e47b1149149CAEc5384427E41A387Bbc17698c</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xd46Ca83fdC20641ce2e225E930FBfb8CE8334660">0xd46Ca83fdC20641ce2e225E930FBfb8CE8334660</a></td><td>15,000</td></tr><tr><td>DAI-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x219BAD3A896964A2B28Ef4dE6Ae6E6D72B646745">0x219BAD3A896964A2B28Ef4dE6Ae6E6D72B646745</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xdE2aA055F8DA4d2a4A5063b8736C8455AEa8aB3F">0xdE2aA055F8DA4d2a4A5063b8736C8455AEa8aB3F</a></td><td>15,000</td></tr><tr><td>DOT-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x2b062807C6B3F8Ca5C366545d50aA19c114E9d7b">0x2b062807C6B3F8Ca5C366545d50aA19c114E9d7b</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x7dc55064b6ea6B75F8A73DC142707aAd0A37541c">0x7dc55064b6ea6B75F8A73DC142707aAd0A37541c</a></td><td>15,000</td></tr><tr><td>BNB-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x731A5AFB6e021579138Ea469B25C2ab46ff44199">0x731A5AFB6e021579138Ea469B25C2ab46ff44199</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xFA4CfAD7DBB1a0b3e85d0b736cf00289edDDDd5F">0xFA4CfAD7DBB1a0b3e85d0b736cf00289edDDDd5F</a></td><td>15,000</td></tr><tr><td>TRX-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xb4de9C81eaA329E1E7161E9a235D795E29eec60D">0xb4de9C81eaA329E1E7161E9a235D795E29eec60D</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x37c7Aac954e721eaBA28c58BeF496529Cde32d5f">0x37c7Aac954e721eaBA28c58BeF496529Cde32d5f</a></td><td>15,000</td></tr><tr><td>BUSD-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xc820F6E9ab1A9321d22720A0986088A9298563ed">0xc820F6E9ab1A9321d22720A0986088A9298563ed</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x6727E828CCa9b5cB639e740d5A275Cd7CdB0b647">0x6727E828CCa9b5cB639e740d5A275Cd7CdB0b647</a></td><td>15,000</td></tr><tr><td>MNR-KRW</td><td><a href="https://baobab.klaytnfinder.io/account/0x22ddDb9749cB5941DdEc5fD50B12CfDdB8E259c9">0x22ddDb9749cB5941DdEc5fD50B12CfDdB8E259c9</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x6DEbE43FD00D3Dcc93D8695a3031fC8887242dee">0x6DEbE43FD00D3Dcc93D8695a3031fC8887242dee</a></td><td>15,000</td></tr></tbody></table>

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
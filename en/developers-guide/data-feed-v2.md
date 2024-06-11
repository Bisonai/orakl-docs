---
description: Continuous stream of off-chain data to your smart contract
---

# Data Feed

A detailed example of how to use **Orakl Network Data Feed** can be found at example repository [`data-feed-consumer`](https://github.com/Bisonai/data-feed-consumer).

## What is Data Feed?

The Orakl Network Data Feed is a secure, reliable, and decentralized source of off-chain data accessible to smart contracts on-chain. The data feed is updated at predefined time intervals, as well as if the data value deviates more than a predefined threshold, to ensure that the data remains accurate and up-to-date. Data feeds can be used in many different on-chain protocols:

- Lending and borrowing
- Mirrored assets
- Stablecoins
- Asset management
- Options and futures
- and many more!

The Orakl Data Feed includes various data feeds that can be used free of charge. The currently supported data feeds can be found in tables below.

### Contract Addresses

Reference following link to check deployed addresses

- [Feeds](https://raw.githubusercontent.com/Bisonai/orakl/master/contracts/v0.2/addresses/datafeeds-addresses.json)
- [Others](https://raw.githubusercontent.com/Bisonai/orakl/master/contracts/v0.2/addresses/others-addresses.json)

## Architecture

The on-chain implementation of Data Feed is composed of two smart contracts: [`Feed`](https://github.com/Bisonai/orakl/blob/master/contracts/v0.2/src/Feed.sol) and [`FeedProxy`](https://github.com/Bisonai/orakl/blob/master/contracts/v0.2/src/FeedProxy.sol). At first,`Feed` and `FeedProxy` are deployed together in pair, representing a single data feed (e.g. temperature in Seoul or price of BTC/USD). `Feed` is being updated at regular intervals by off-chain oracles, and `FeedProxy` is used to access the submitted data to `Feed`. Deployed `FeedProxy` contract represents a consistent API to read data from the feed, and `Feed` contract can be replaced with a newer version.

In the rest of the page, we will focus on [how to read from data feed](data-feed-v2.md#how-to-read-from-data-feed) and [explain relation between `Feed` and `FeedProxy`](data-feed-v2.md#relation-between-feedproxy-and-feed).

## How to read from data feed?

In this section, we will explain how to integrate Orakl Network data feed to your smart contract to be able to read from any data feed. We will also point out potential issues you might encounter and how to solve them.

The section is split into following topics:

- [Initialization](data-feed-v2.md#initialization)
- [Read Data](data-feed-v2.md#read-data)
- [Process Data](data-feed-v2.md#process-data)

### Initialization

The access to data feed is provided through the `FeedProxy` address corresponding to a data feed of your choice, and [`IFeedProxy`](https://github.com/Bisonai/orakl/blob/master/contracts/v0.2/src/interfaces/IFeedProxy.sol) from [`@bisonai/orakl-contracts`](https://www.npmjs.com/package/@bisonai/orakl-contracts).

```solidity
import { IFeedProxy } from "@bisonai/orakl-contracts/src/v0.2/interfaces/IFeedProxy.sol";

contract DataFeedConsumer {
    IFeedProxy internal dataFeed;
    constructor(address feedProxy) {
        dataFeed = IAggregator(feedProxy);
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
    uint updatedAt
) = dataFeed.latestRoundData();
```

Submissions are divided into rounds and indexed by an `id`. Node operators are expected to report submission in every round, and aggregate is computed from all submissions in the same round. Submissions from previous rounds can be queried through `getRoundData` function which requires a single extra parameter `roundId`. The output format is same as from `latestRoundData` function.

```solidity
uint80 roundId =
(
    uint80 id,
    int256 answer,
    uint updatedAt
) = dataFeed.getRoundData(roundId);
```

### Process Data

The values returned from `latestRoundData()` and `getRoundData(roundId)` functions do not include only the data feed value (=`answer`) at corresponding round `id` but also `updatedAt`

`updatedAt` represents the timestamp when the round was updated last time.

> We highly recommend you to keep track of all metadata returned by both `latestRoundData()` and `getRoundData(roundId)`. If your application is dependent on frequent updates, you have to make sure in application layer that data returned by any of these functions is not stale.

`feedProxy` has several other auxiliary functions that should be utilized in order to avoid any issues from misrepresenting the `answer` returned from data feed.

All `answer`s are returned with a specific decimal precision that can be queried using `decimals()` function.

```solidity
uint8 decimals = dataFeed.decimals();
```

`FeedProxy` is always connected to a single `Feed`, but this connection is not fixed and `Feed` can be changed. If you want to make sure that you are still using the same `Feed` you can ask for the `Feed` address through `getFeed()` function.

```solidity
address currentAggregator = dataFeed.getFeed()
```

### Use Feed Router

- Conveniently access data feeds using `FeedRouter` contract
- Access all functions in `FeedProxy` by including price pair name as parameter

Initialize AggregatorRouter that enables access to all supported data feeds.

```solidity
import { IFeedRouter } from "@bisonai/orakl-contracts/src/v0.2/interfaces/IFeedRouter.sol";
contract DataFeedConsumer {
    IFeedRouter internal router;
    constructor(address _router) {
        router = IFeedRouter(_router);
    }
}
```

Read the latest submitted value of given data feed (e.g. "BTC-USDT")

```solidity
(
   uint80 id,
    int256 answer,
    uint updatedAt
) = router.latestRoundData("BTC-USDT");
```

Read value submitted to a given data feed (e.g. "BTC-USDT") for specific roundId.

```solidity
uint80 roundId =
(
    uint80 id,
    int256 answer,
    uint updatedAt
) = router.getRoundData("BTC-USDT", roundId);
```

Get decimals for given data feed (e.g. "BTC-USDT")

```solidity
uint8 decimals = router.decimals("BTC-USDT");
```

Get Feed address associated with given data feed (e.g. "BTC-USDT").

```solidity
address currentFeed = router.feed("BTC-USDT")
```

## Relation between `FeedProxy` and `Feed`

When deploying an`FeedProxy` , `Feed`'s address has to be specified to create a connection between the contracts. Consumer can then request data through `latestRoundData` or `getRoundData` functions, and data will be fetched from `Feed` that is represented by the `feedAddress`.

```solidity
constructor(address _feed) {
    setFeed(_feed);
}
```

At times, it might be necessary to update the address of `Feed`. If the `Feed` address is updated, a queried data feed will come from a different `Feed` than before the update. `FeedProxy`'s update of `Feed` is split into two steps: proposal and confirmation. Both steps can be only executed with `onlyOwner` privileges.

`proposeFeed` stores the proposed address to storage variable and emits event about new address being proposed.

```solidity
 function proposeFeed(address _feed) external onlyOwner {
        if (_feed == address(0)) {
            revert InvalidProposedFeed();
        }
        proposedFeed = IFeed(_feed);
        emit FeedProposed(address(feed), _feed);
    }
```

After the new `Feed` is proposed, one can query a new data feed through a special functions: `latestRoundDataFromProposedFeed` and `getRoundDataFromProposedFeed`. These functions are useful for testing a new data feed, before accepting the new proposed `Feed`.

The function `confirmFeed` is used to finalize the transition to the new proposed `Feed`, and can be executed only with account that has `onlyOwner` privilege. New aggregator is finalized through `setFeed` (called also inside of `constructor` of `FeedProxy`). Finally, the new aggregator is announced through emitted event.

```solidity
function confirmFeed(address _feed) external onlyOwner {
        if (_feed != address(proposedFeed)) {
            revert InvalidProposedFeed();
        }
        address previousFeed = address(feed);
        delete proposedFeed;
        setFeed(_feed);
        emit FeedConfirmed(previousFeed, _feed);
    }
```

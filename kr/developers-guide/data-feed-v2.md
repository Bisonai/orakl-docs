---
description: Continuous stream of off-chain data to your smart contract
---

# Data Feed

**Orakl Network Data Feed** 사용 예제는 예제 저장소인 [`data-feed-consumer`](https://github.com/Bisonai/data-feed-consumer)에서 자세히 확인하실 수 있습니다.

## What is Data Feed?

Orakl Network 데이터 피드는 스마트 계약에서 온체인으로 접근할 수 있는 안전하고 신뢰할 수 있는 탈중앙화된 오프체인 데이터의 원천입니다. 데이터 피드는 미리 정의된 시간 간격으로 업데이트되며, 데이터 값이 미리 정의된 임계값을 초과하는 경우에도 업데이트되어 데이터의 정확성과 최신성을 유지합니다. 데이터 피드는 다양한 온체인 프로토콜에서 사용될 수 있습니다:

- Lending and borrowing(대출 및 차입)
- Mirrored assets(기존 자산의 가치와 움직임을 반영한 디지털 자산)
- Stablecoins(스테이블코인)
- Asset management(자산 관리)
- Options and futures(옵션 및 선물)
- 그 외에도 다양한 용도로 활용될 수 있습니다!

Orakl 데이터 피드에는 무료로 사용할 수 있는 다양한 데이터 피드가 포함되어 있습니다. 현재 지원되는 데이터 피드는 아래 표에서 확인하실 수 있습니다.

### Contract Addresses

배포된 컨트랙트 주소는 다음을 참고하십시오.

- [Feeds](https://raw.githubusercontent.com/Bisonai/orakl/master/contracts/v0.1/deployments/datafeeds-addresses.json)
- [Others](https://raw.githubusercontent.com/Bisonai/orakl/master/contracts/v0.1/deployments/other-addresses.json)

## Architecture

데이터 피드의 온체인 구현은 [`Feed`](https://github.com/Bisonai/orakl/blob/master/contracts/v0.2/src/Feed.sol) 와 [`FeedProxy`](https://github.com/Bisonai/orakl/blob/master/contracts/v0.2/src/FeedProxy.sol) 두 개의 스마트 계약으로 구성됩니다. 처음에는 `Feed` 와 `FeedProxy` 가 함께 쌍으로 배포되어 단일 데이터 피드 (예: 서울의 온도 또는 BTC/USD의 가격)를 나타냅니다. `Feed` 는 오프체인 오라클에 의해 정기적으로 업데이트되며, and `FeedProxy` 는 `Feed` 에 제출된 데이터에 액세스하는 데 사용됩니다. 배포된 `FeedProxy` 계약은 데이터 피드에서 읽기 위한 일관된 API를 제공하며, `Feed` 컨트랙트는 더 최신 버전으로 대체될 수 있습니다.

나머지 페이지에서는 [데이터 피드에서 읽는 방법](data-feed-v2.md#how-to-read-from-data-feed) 에 중점을 두고 [`Feed` 와 `FeedProxy` 간의 관계](data-feed-v2.md#relation-between-feedproxy-and-feed) 를 설명하겠습니다.

## How to read from data feed?

이 섹션에서는 Orakl Network 데이터 피드를 스마트 계약에 통합하여 어떤 데이터 피드에서든 읽을 수 있는 방법을 설명합니다. 또한 발생할 수 있는 잠재적인 문제점과 해결 방법에 대해서도 언급할 예정입니다.

이 섹션은 다음과 같은 주제로 구성됩니다:

- [Initialization](data-feed-v2.md#initialization)
- [Read Data](data-feed-v2.md#read-data)
- [Process Data](data-feed-v2.md#process-data)

### Initialization

데이터 피드에 대한 액세스는 선택한 데이터 피드에 해당하는 `FeedProxy` 주소 및 [`@bisonai/orakl-contracts`](https://www.npmjs.com/package/@bisonai/orakl-contracts) 의 [`IFeedProxy`](https://github.com/Bisonai/orakl/blob/master/contracts/v0.2/src/interfaces/IFeedProxy.sol) 를 통해 제공됩니다.

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

데이터는 `latestRoundData()` 와 `getRoundData(roundId)` 함수를 사용하여 피드에서 쿼리할 수 있습니다.

`latestRoundData` 함수는 최신 제출에 대한 메타데이터를 반환합니다.

```solidity
(
   uint80 id,
    int256 answer,
    uint updatedAt
) = dataFeed.latestRoundData();
```

제출은 라운드로 분할되며 `id` 로 인덱싱됩니다. 노드 운영자들은 매 라운드마다 제출을 보고하고, 동일한 라운드의 모든 제출에서 집계가 계산됩니다. 이전 라운드의 제출은 `roundId`라는 추가 매개변수를 필요로 하는 `getRoundData` 함수를 통해 쿼리할 수 있습니다. 출력 형식은 `latestRoundData` 함수와 동일합니다.

```solidity
uint80 roundId =
(
    uint80 id,
    int256 answer,
    uint updatedAt
) = dataFeed.getRoundData(roundId);
```

### Process Data

`latestRoundData()` 및 `getRoundData(roundId)` 함수에서 반환되는 값은 해당 라운드 `id`의 데이터 피드 값 (=`answer`) 뿐만 아니라 `updatedAt` 값도 포함합니다.

`updatedAt` 은 라운드가 마지막으로 업데이트된 타임스탬프를 나타냅니다.

> `latestRoundData()` 와 `getRoundData(roundId)` 에서 반환된 모든 메타데이터를 추적하는 것을 강력히 권장합니다. 애플리케이션이 빈번한 업데이트에 의존하는 경우, 이러한 함수 중 어느 하나로 반환된 데이터가 오래된 것이 아닌지를 애플리케이션 계층에서 확인해야 합니다.

`FeedProxy`에는 데이터 피드에서 반환된 `응답`을 잘못 표현하는 문제를 방지하기 위해 활용해야 하는 여러 보조 함수가 있습니다.

모든 `응답들`은 특정 소수 자릿수로 반환되며, 이 소수 자릿수는 `decimals()` 함수를 사용하여 조회할 수 있습니다.

```solidity
uint8 decimals = dataFeed.decimals();
```

`FeedProxy` 는 항상 하나의 `Feed` 에 연결되어 있지만, 이 연결은 고정되어 있지 않으며 `Feed` 를 변경할 수 있습니다. 동일한 `Feed` 를 계속 사용하고 있는지 확인하려면 `getFeed()` 함수를 통해 `Feed` 주소를 요청할 수 있습니다.

```solidity
address currentAggregator = dataFeed.getFeed()
```

### Use Feed Router

- Router Contract를 통해 편리하게 적용할 수 있습니다
- 호출함수에 가격 페어 이름(ex.BTC-USDT)을 전달하고 모든 aggregator기능에 접근해보세요

모든 피드에 접근 가능한 AggregatorRouter를 초기화합니다

```solidity
import { IFeedRouter } from "@bisonai/orakl-contracts/src/v0.2/interfaces/IFeedRouter.sol";
contract DataFeedConsumer {
    IFeedRouter internal router;
    constructor(address _router) {
        router = IFeedRouter(_router);
    }
}
```

주어진 데이터피드의 최신 데이터에 접근합니다 (ex. "BTC-USDT")

```solidity
(
   uint80 id,
    int256 answer,
    uint updatedAt
) = router.latestRoundData("BTC-USDT");
```

주어진 데이터피드의 특정 roundId의 가격 정보를 가져옵니다 (ex. "BTC-USDT")

```solidity
uint80 roundId =
(
    uint80 id,
    int256 answer,
    uint updatedAt
) = router.getRoundData("BTC-USDT", roundId);
```

주어진 데이터피드의 decimals값을 가져옵니다

```solidity
uint8 decimals = router.decimals("BTC-USDT");
```

주어진 데이터피드의 aggregator주소를 가져옵니다

```solidity
address currentFeed = router.feed("BTC-USDT")
```

## Relation between `FeedProxy` and `Feed`

`FeedProxy` 를 배포할 때, `Feed`의 주소를 지정하여 계약 간에 연결을 생성해야 합니다. 그러면 컨슈머는 `latestRoundData` 또는 `getRoundData` 함수를 통해 데이터를 요청할 수 있으며, 데이터는 `feedAddress`로 표시된 `Feed`에서 가져옵니다.

```solidity
constructor(address aggregatorAddress) {
    setFeed(aggregatorAddress);
}
```

가끔은 `Feed`의 주소를 업데이트하는 것이 필요할 수 있습니다. `Feed` 주소가 업데이트되면 조회된 데이터 피드는 이전과 다른 `Feed`에서 가져옵니다. `FeedProxy`의 `Feed` 업데이트는 제안 단계와 확인 단계로 나누어집니다. 두 단계 모두 `onlyOwner` 권한으로 실행할 수 있습니다.

`proposeFeed` 함수는 제안된 주소를 저장하는 저장소 변수에 저장하고, 새로운 주소에 대한 이벤트를 발생시킵니다.

```solidity
 function proposeFeed(address _feed) external onlyOwner {
        if (_feed == address(0)) {
            revert InvalidProposedFeed();
        }
        proposedFeed = IFeed(_feed);
        emit FeedProposed(address(feed), _feed);
    }
```

새로운 `Feed`가 제안된 후에는, `latestRoundDataFromProposedFeed` , `getRoundDataFromProposedFeed`와 같은 특수한 함수를 통해 새로운 데이터 피드를 조회하실 수 있습니다. 이 함수들은 새롭게 제안된 `Feed`를 수락하기 전에 새로운 데이터 피드를 테스트하는 데 유용합니다.

`confirmFeed` 함수는 새롭게 제안된 `Feed` 로의 전환을 확정하기 위해 사용되며, `onlyOwner` 권한을 가진 계정에서만 실행할 수 있습니다. 새로운 Aggregator는 `setFeed`를 통해 확정됩니다 (`FeedProxy`의 `constructor` 내에서도 호출됩니다). 마지막으로, 새로운 Aggregator는 발생한 이벤트를 통해 공지됩니다.

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
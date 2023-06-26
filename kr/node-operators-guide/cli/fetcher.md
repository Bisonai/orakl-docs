---
description: Start And Stop Data Collection
---

# Fetcher

> 만약 **Orakl Network Data Feed Operator** 가 아니신 경우, 이 페이지의 설명을 참고하실 필요는 없습니다.

**Orakl Network CLI**는 다음과 같은 명령을 제공합니다:

- [Start Single Data Feed Collection](fetcher.md#start-single-data-feed-collection)
- [Stop Single Data Feed Collection](fetcher.md#stop-single-data-feed-collection)

**Orakl Network Fetcher** adapter의 정의에 기반하여 정기적으로 데이터를 수집하는 데 사용됩니다. 수집 및 집계된 데이터는 **Orakl Network Data Feed**에서 사용할 수 있습니다.

### Start Single Data Feed Collection

**Orakl Network Fetcher**는 `fetcher start` 명령을 사용하여 등록된 aggregator의 즉시 데이터 수집을 시작할 수 있습니다. Aggregator 는 여러 `chains`에 등록될 수 있으므로 `--chain` 매개변수를 통해 적절한 체인을 지정해야 합니다.&#x20;

```sh
orakl-cli fetcher start \
    --id ${aggregatorhash} \
    --chain ${chainName}
```

### Stop Single Data Feed Collection

Orakl Network Fetcher가 수행하는 데이터 수집은 `fetcher stop` 명령을 사용하여 중지할 수 있습니다.

```sh
orakl-cli fetcher stop \
    --id ${aggregatorhash} \
    --chain ${chainName}
```

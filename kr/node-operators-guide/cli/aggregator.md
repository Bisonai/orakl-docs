---
description: List, Insert And Remove Orakl Network Aggregators
---

# Aggregator

> 만약 **Orakl Network Data Feed Operator** 가 아니신 경우, 이 페이지의 설명을 참고하실 필요는 없습니다.

**Orakl Network CLI** 는 다음과 같은 command를 제공합니다:

- [List Aggregators](aggregator.md#list-aggregators)
- [Insert New Aggregator](aggregator.md#insert-new-aggregator)
- [Remove Aggregator Specified By `id`](aggregator.md#remove-aggregator-specified-by-id)

### What Is Aggregator?

Aggregator는 **Orakl Network Data Feed** 솔루션의 추상화입니다. 각각의 aggregator는 `adapterHash`를 통해 어댑터가 할당되며, 데이터 피드의 최소 업데이트 빈도를 `heartbeat` 속성을 통해 추가로 정의합니다. 데이터 피드는 **Orakl Network Fetcher** 에 의해 모니터링되어 사전에 정의된 `임계값` 또는 `절대 임계값` 을 초과하는 편차를 감지합니다. `address` 속성은 집계된 데이터 피드 값이 업데이트되는 위치를 지정합니다.

`BTC-USD` 데이터 피드의 예시로서, 최소 15초마다 업데이트되는 aggregator를 온체인으로 설정한 경우입니다.

```sh
{
  "aggregatorHash": "0xfda8c08a8b7641e001ad23c0fb363a9e7aab1e3a7eb8a6ddee41deeb7e3ef279",
  "name": "BTC-USD",
  "address": "0x15c0b3ea93ed4de0a1f93f4ae130aefd8f2e8ccb",
  "heartbeat": 15000,
  "threshold": 0.05,
  "absoluteThreshold": 0.1,
  "adapterHash": "0xe63985ed9d9aae887bdcfa03b53a1bea6fd1acc58b8cd51a9a69ede43eac6235"
}
```

### List Aggregators

등록된 모든 aggregator는 `aggregator list` command를 사용하여 나열할 수 있습니다. 특정 체인의 aggregator만 보고 싶은 경우 `--chain`매개변수를 사용할 수 있습니다.

```sh
orakl-cli aggregator list \
    --chain ${chain}
```

### Insert New Aggregator

aggregator 정의도 adapter와 마찬가지로 상당히 길어질 수 있습니다. 이를 위해 새로운 aggregator를 등록할 수 있도록 `--source` 매개변수를 지원합니다. 이 매개변수는 로컬 컴퓨터에 있는 JSON 집계기 파일이나 웹에서 호스팅된 JSON aggregator 파일을 가리킬 수 있습니다. 또한, 새로 추가된 aggregator 를 연결할 `체인`을 지정해야 합니다.

[Orakl Network 데이터 피드 구성 페이지](https://config.orakl.network/) 에서 사전 정의된 aggregator 정의를 사용할 수 있습니다.

```sh
orakl-cli aggregator insert \
    --source ${pathOrUrlToAggregatorJsonFile} \
    --chain ${chain}
```

### Remove Aggregator Specified By `id`&#x20;

비활성화된 경우에만 Orakl Network 상태에서 aggregator를 제거할 수 있습니다. 비활성화된 aggregator는 aggregator 식별자를 나타내는 추가 `--id` 매개변수와 함께 제공되는 `aggregator remove` command로 제거할 수 있습니다.

```sh
orakl-cli aggregator remove \
    --id ${id}
```

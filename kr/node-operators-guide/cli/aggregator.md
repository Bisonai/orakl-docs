---
description: List, Insert And Remove Orakl Network Aggregators
---

# Aggregator

> 만약 **Orakl Network Data Feed Operator** 가 아니신 경우, 이 페이지의 설명을 참고하실 필요는 없습니다.

**Orakl Network CLI** 는 다음과 같은 command를 제공합니다:

- [List Aggregators](aggregator.md#list-aggregators)
- [List Active Aggregators](aggregator.md#list-active-aggregators)
- [Insert New Aggregator](aggregator.md#insert-new-aggregator)
- [Remove Aggregator Specified By `id`](aggregator.md#remove-aggregator-specified-by-id)
- [Activate Aggregator](aggregator.md#activate-aggregator)
- [Deactivate Aggregator](aggregator.md#deactivate-aggregator)

### What Is Aggregator?

Aggregator 는 **Orakl Network Data Feed** 솔루션의 추상화입니다. 각 aggregator 는 `adapterHash` 를 통해 어댑터를 할당받으며, `heartbeat` 속성을 통해 각 데이터 피드의 최소 업데이트 주기를 정의합니다. 데이터 피드는 **Orakl Network Fetcher** 로 모니터링되어 미리 정의된 `임계값(threshold)` 이나 `절대 임계값(absoluteThreshold)` 을 초과하는 편차를 감지합니다. `address` 속성은 집계된 데이터 피드 값이 업데이트되는 위치를 지정합니다.

BTC-USD 데이터 피드의 예시로, 체인 상에서 최소 15초마다 업데이트되는 Aggregator입니다.

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

### List Active Aggregators

`aggregator list` command로 표시되는 Aggregator들은 **Orakl Network** 의 영구 저장소에 저장됩니다. **Orakl Network Data Feed Worker** 가 실행될 때, 모든 Aggregator들은 일시적인 저장소에 복제됩니다. 모든 활성 Aggregator를 확인하려면 `aggregator active` command를 사용하세요.

이 command에는 `--host` 와 `--port` 라는 두 가지 선택적 매개변수가 필요합니다. 이는 각각 **Orakl Network Data Feed Worker** 의 watchman 호스트와 포트를 나타냅니다. 이 값들은 `WORKER_SERVICE_HOST` 와 `WORKER_SERVICE_PORT` 환경 변수를 통해 미리 정의할 수 있습니다.

```bash
orakl-cli aggregator active \
    [--host ${DATA_FEED_WORKER_HOST}] \
    [--port ${DATA_FEED_WORKER_PORT}]
```

### Insert New Aggregator

aggregator 정의도 adapter와 마찬가지로 상당히 길어질 수 있습니다. 이를 위해 새로운 aggregator를 등록할 수 있도록 `--source` 매개변수를 지원합니다. 이 매개변수는 로컬 컴퓨터에 있는 JSON aggregator 파일이나 웹에서 호스팅된 JSON aggregator 파일을 가리킬 수 있습니다. 또한, 새로 추가된 aggregator 를 연결할 `체인`을 지정해야 합니다.

[Orakl Network 데이터 피드 구성 페이지](https://config.orakl.network/) 에서 사전 정의된 aggregator 정의를 사용할 수 있습니다.

`aggregator insert` command를 사용하여 추가한 aggregator는 서비스가 다시 시작되지 않는 한 **Orakl Network Data Feed Worker** 에서 인식되지 않습니다. 서비스를 다시 시작하기 전까지는 새로운 aggregator를 실행할 수 없습니다. 이미 실행 중인 서비스에서 새로운 aggregator를 실행하려면 insert 후에 [aggregator를 활성화](aggregator.md#activate-aggregator)해야 합니다.

```sh
orakl-cli aggregator insert \
    --source ${pathOrUrlToAggregatorJsonFile} \
    --chain ${chain}
```

### Remove Aggregator Specified By `id`

비활성화된 경우에만 **Orakl Network** 상태에서 aggregator를 제거할 수 있습니다. 비활성화된 aggregator는 aggregator 식별자를 나타내는 추가 `--id` 매개변수와 함께 제공되는 `aggregator remove` command로 제거할 수 있습니다.

```sh
orakl-cli aggregator remove \
    --id ${id}
```

### Activate Aggregator

**Orakl Network Data Feed Worker** 가 이미 실행 중이라면, Orakl Network의 영구 저장소만을 수정하는 `aggregator insert` command를 사용하는 것으로는 충분하지 않습니다. Aggregator의 정의를 영구 저장소에서 일시적 저장소로 전송해야 합니다. 실행 중인 **Orakl Network Data Feed Worker** 서비스에서 aggregator를 활성화하려면 `aggregator activate` command를 사용하세요.

이 command에는 `--host` 와 `--port` 라는 두 가지 선택적 매개변수가 필요합니다. 이는 각각 **Orakl Network Data Feed Worker** 의 watchman 호스트와 포트를 나타냅니다. 이 값들은 `WORKER_SERVICE_HOST` 와 `WORKER_SERVICE_PORT` 환경 변수를 통해 미리 정의할 수 있습니다.

```bash
orakl-cli aggregator activate \
    --aggregatorHash ${aggregatorHash} \
    [--host ${DATA_FEED_WORKER_HOST}] \
    [--port ${DATA_FEED_WORKER_PORT}]
```

### Deactivate Aggregator

**Orakl Network Data Feed Worker** 가 실행 중이고 데이터 피드 중 일부를 중지해야 할 경우, `aggregator deactivate` command를 사용하세요. 이 command는 `aggregatorHash` 로 정의된 단일 aggregator를 일시적 저장소에서 제거하며, 다른 활성 데이터 피드에는 영향을 주지 않습니다.

이 command에는 `--host` 와 `--port` 라는 두 가지 선택적 매개변수가 필요합니다. 이는 각각 **Orakl Network Data Feed Worker** 의 watchman 호스트와 포트를 나타냅니다. 이 값들은 `WORKER_SERVICE_HOST` 와 `WORKER_SERVICE_PORT` 환경 변수를 통해 미리 정의할 수 있습니다.

```bash
orakl-cli aggregator deactivate \
    --aggregatorHash ${aggregatorHash} \
    [--host ${DATA_FEED_WORKER_HOST}] \
    [--port ${DATA_FEED_WORKER_PORT}]
```

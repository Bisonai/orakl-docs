---
description: List, Inser, Remove, Activate And Deactivate Orakl Network Listeners
---

# Listener

**Orakl Network Listener** 는 Orakl Network 솔루션 (VRF, Request-Response and Aggregator)에 포함된 마이크로서비스입니다. Listener 구성에는 [`chain`](chain.md), [`service`](service.md), `address` 및 `eventName` 속성이 포함됩니다. **Orakl Network Listener** 는 smart contract `address` 에서 `eventName` 으로 정의된 이벤트를 수신합니다.

**Orakl Network CLI** 는 **Orakl Network Listener** 의 [영구적](listener.md#permanent-state) 이거나 [일시적인 상태](listener.md#ephemeral-state) 를 수정하기 위한 command를 제공합니다. 지원되는 작업 목록은 다음과 같습니다:

- [List Listeners](listener.md#list-listeners)
- [Insert New Listener](listener.md#insert-new-listener)
- [Remove Listener Specified By `id`](listener.md#remove-listener-specified-by-id)
- [List Active Listeners](listener.md#list-active-listeners)
- [Activate Listener](listener.md#activate-listener)
- [Deactivate Listener](listener.md#deactivate-listener)

## Permanent State

**Orakl Network Listener** 서비스가 시작될 때 영구적인 리스너 상태가 로드됩니다. 이 상태는 **Orakl Network Worker** 나 **Orakl Network Reporter** 와 같은 다른 서비스에서 접근하지 않습니다.

### List Listeners

영구 상태로 유지되는 리스너들은 `listener list` command를 사용하여 표시할 수 있습니다. 선택적 매개변수인 [`--chain`](chain.md) 또는 [`--service`](service.md) 를 사용하여 리스너를 필터링할 수도 있습니다.

```sh
orakl-cli listener list \
    [--chain ${chain}] \
    [--service ${service}]
```

아래에는 `listener list` command의 예시 입니다. 세 가지 다른 리스너를 가지고 있으며, 각각은 세 가지 다른 이벤트 `RandomWordsRequested`, `NewRound` 및 `DataRequested` 를 위해 세 개의 주소에서 수신을 해야 합니다.

```json
[
  {
    "id": "1",
    "address": "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
    "eventName": "RandomWordsRequested",
    "service": "VRF",
    "chain": "baobab"
  },
  {
    "id": "2",
    "address": "0xa513E6E4b8f2a923D98304ec87F64353C4D5C853",
    "eventName": "NewRound",
    "service": "DATA_FEED",
    "chain": "baobab"
  },
  {
    "id": "3",
    "address": "0x45778c29A34bA00427620b937733490363839d8C",
    "eventName": "DataRequested",
    "service": "REQUEST_RESPONSE",
    "chain": "baobab"
  }
]
```

특정 체인과 연관된 리스너를 나열하려면 `--chain` 매개변수를 사용할 수 있습니다.

```sh
orakl-cli listener list \
    --chain ${chain}
```

특정 서비스와 연관된 리스너를 나열하려면 `--service` 매개변수를 사용할 수 있습니다.

```sh
orakl-cli listener list \
    --service ${service}
```

### Insert New Listener

영구적인 리스너 상태에 새로운 리스너를 추가하려면 `listener insert` 명령을 사용할 수 있습니다.

```sh
orakl-cli listener insert \
    --chain ${chain} \
    --service ${service} \
    --address ${address} \
    --eventName ${eventName}
```

### Remove Listener Specified By `id`

영구적인 리스너 상태에서 리스너를 제거하기 위해 `listener remove` 명령을 사용할 수 있습니다. 제거할 리스너는 식별자 (`--id`)로 지정됩니다. 이를 통해 특정 리스너를 식별하여 영구적인 리스너 상태에서 제거할 수 있습니다.

```sh
orakl-cli listener remove \
    --id ${id}
```

## Ephemeral State

임시 리스너 상태는 **Orakl Network Listener** 서비스가 시작될 때 생성되며, 종료될 때까지 수명기간 내내 사용됩니다. [Permanent State section](listener.md#permanent-state) 의 모든 명령은,`activate` 또는 `deactivate` 명령을 적용하지 않는 한 임시 리스너 상태에 영향을 주지 않습니다.

영구 리스너 상태와는 달리 임시 리스너 상태는 **Orakl Network Listener** 서비스 내부에서 실행되는 watchman을 통해 액세스됩니다. 이러한 이유로 임시 상태에 액세스해야하는 모든 명령은 네트워크에서 **Orakl Network Listener** 의 위치를 정의하는 `--host` 및 `--port` 매개변수를 지정해야 합니다.

### List Active Listeners

**Orakl Network Listener** 서비스가 시작될 때 영구 상태에 포함된 모든 리스너는 자동으로 활성화되며, `listener active` 명령을 사용하여 확인할 수 있습니다. [이후에 활성화된 리스너](listener.md#activate-listener) 도 이 명령을 통해 확인할 수 있습니다. 활성화되지 않은 상태인 리스너는 해당 구성에서 이벤트를 수신하지 않습니다.

```sh
orakl-cli listener active \
    --host ${host} \
    --port ${port}
```

### Activate Listener

**Orakl Network Listener** 서비스 시작 후 영구 리스너 상태에 추가된 리스너는 기본적으로 비활성화됩니다. 비활성화된 리스너는 `listener activate` 명령과 `--id` 매개변수를 사용하여 활성화할 수 있습니다. 리스너 식별자는 [`listener list` command](listener.md#list-listeners)를 통해 확인할 수 있습니다. 리스너가 활성화되면 해당 구성에서 정의된 이벤트를 수신하기 시작합니다.

```sh
orakl-cli listener activate \
    --id ${id}
    --host ${host} \
    --port ${port}
```

### Deactivate Listener

새로운 활성 리스너는 추가적인 계산 자원이 필요하지만, 일반적으로 오버헤드가 낮게 작동합니다. 리스너가 기다리고 있던 이벤트를 감지하면 **Orakl Network Worker**를 위한 새로운 작업을 생성하고,그 작업은 **Orakl Network Reporter**에게 전달됩니다. 필요하지 않은 리스너를 추가하면 전체 시스템에 불필요하게 높은 부하를 야기할 수 있습니다.

시스템 부하를 낮추기 위해 리스너를 비활성화하려면 `listener deactivate` command를 사용할 수 있습니다.

```sh
orakl-cli listener deactivate \
    --id ${id}
    --host ${host} \
    --port ${port}
```

> 만약 리스너를 장기적으로 사용하지 않을 경우, [영구 리스너 상태에서 제거](listener.md#remove-listener-specified-by-id)해야 합니다. 그렇지 않으면 **Orakl Network Listener** 가 재시작되면 활성화될 수 있습니다.

---
description: List, Insert, Remove, Activate, Deactivate And Refresh Orakl Network Reporters
---

# Reporter

> 만약 **Orakl Network Data Feed Operator** 가 아니신 경우, 이 페이지의 설명을 참고하실 필요는 없습니다.

**Orakl Network CLI** 는 **Orakl Network Reporter** 의 [permanent](reporter.md#permanent-state) 또는 [ephemeral state](reporter.md#ephemeral-state)를 수정하는 command를 제공합니다. 지원되는 작업 목록은 다음과 같습니다:

Orakl Network CLI는 Orakl Network Reporter의 영구 또는 일시적인 상태를 수정하는 command를 제공합니다. 지원되는 작업 목록은 다음과 같습니다:

- [List Reporters](reporter.md#list-reporters)
- [Insert New Reporter](reporter.md#insert-new-reporter)
- [Remove Reporter Specified By `id`](reporter.md#remove-reporter-specified-by-id)
- [List Active Reporters](reporter.md#list-active-reporters)
- [Activate Reporter](reporter.md#activate-reporter)
- [Deactivate Reporter](reporter.md#deactivate-reporter)
- [Refresh Reporters](reporter.md#refresh-reporters)

## What Is Reporter?

Reporter는 외부 소유 계정(EOA) 및 그와 관련된 온체인 오라클을 위한 추상화입니다. Reporter는 주소 (`oracleAddress`)로 지정된 오라클에 대해서만 미리 정의된 `chain`의 특정 `service` 대한 트랜잭션을 수행할 수 있습니다.

Reporter 메타데이터는 **Orakl Network** 의 모든 서비스 (**Orakl Network Listener**, **Orakl Network Worker** 및 **Orakl Network Reporter**)에서 사용됩니다.

## Permanent State

Reporter 영구적인 상태는 **Orakl Network Reporter** 서비스를 시작할 때 로드되며, **Orakl Network Listener** 및 **Orakl Network Worker** 에서 필요할 때마다 액세스됩니다.

### List Reporters

모든 등록된 reporter는 `reporter list` command를 사용하여 나열할 수 있습니다. 특정 체인이나 서비스에 대한 리포터만 확인하고 싶다면 각각 `--chain` 매개변수 또는 `--service` 매개변수를 사용할 수 있습니다. `--chain` 과 `--service` 매개변수는 모두 선택적입니다.

```sh
orakl-cli reporter list \
    [--chain ${chain}] \
    [--service ${service}
```

- example

```sh
orakl-cli reporter list --chain baobab --service VRF
```

### Insert New Reporter

새 reporter를 추가하려면 `reporter insert` command를 사용할 수 있습니다. 이 command에는 세 가지 그룹의 매개변수가 필요합니다: EOA 관련, oracle 관련 및 category 관련 매개변수입니다. EOA 매개변수 (`--address` 및 `--privateKey`) 는 이 reporter의 월렛을 생성하고 온체인 스마트 계약에 트랜잭션을 생성하고 전송하는 데 사용됩니다. Oracle 매개변수 (`oracleAddress`)는 이 reporter의 월렛이 실행할 수 있는 스마트 계약을 정의합니다. **Orakl Network** 는 동일한 월렛에서 동일한 시간대에 여러 트랜잭션이 발행될 때 확장성 문제를 제한하기 위해 각 스마트 계약마다 단일 EOA를 사용합니다. 마지막으로, category 매개변수 (`--chain` 및 `--service`) 는 체인 및 서비스별로 reporter를 구분하는 데 사용됩니다.

```sh
orakl-cli reporter insert \
  --chain ${chain} \
  --service ${service} \
  --address ${address} \
  --privateKey ${privateKey} \
  --oracleAddress ${oracleAddress}
```

- example

```sh
orakl-cli reporter insert --chain baobab --service VRF --address 0x12 --privateKey abc12 --oracleAddress 0xab
```

### Remove Reporter Specified By `id`

Reporter는 언제든지 **Orakl Network** 상태에서 제거할 수 있지만, 이는 **Orakl Network**의 즉각적인 변화에 영향을 주지 않습니다. **Orakl Network Reporter service** 내에서 즉각적인 변경이 필요한 경우 `reporter deactivate` command를 사용하세요.

Reporter는 reporter의 식별자를 나타내는 추가 `--id` 매개변수와 함께 제공되는 `reporter remove` command를 사용하여 제거할 수 있습니다.

```sh
orakl-cli reporter remove \
    --id ${id}
```

- example

```sh
orakl-cli reporter remove --id 15
```

## Ephemeral State

Reporter의 임시 상태는 **Orakl Network Reporter** 서비스가 시작될 때 생성되며 종료될 때까지 수명기간 내내 사용됩니다. [영구 상태 섹션](reporter.md#permanent-state)의 모든 command는 `activate`, `deactivate` 또는 `refresh` 같은 아래에 설명된 command를 적용하지 않는 한 임시 상태에 영향을주지 않습니다.

영구적인 reporter 상태와 달리, 임시 reporter 상태는 **Orakl Network Reporter** 서비스 내에서 실행되는 감시자를 통해 액세스됩니다. 이러한 이유로 임시 상태에 액세스하는 모든 command는 네트워크에서 **Orakl Network Reporter** 서비스의 위치를 정의하는 `--host` 및 `--port` 매개변수를 지정해야 합니다.

### List Active Reporters

**Orakl Network Reporter** 서비스 시작 시 영구적인 상태에 포함된 모든 reporter는 자동으로 활성화되며, `reporter active` command를 통해 목록을 확인할 수 있습니다. [이후에 활성화된 Reporter들](reporter.md#activate-reporter)도 동일한 command를 통해 확인할 수 있습니다. Reporter가 활성 상태가 아닌 경우에는 해당 오라클로 트랜잭션을 전송할 수 없습니다.

```sh
orakl-cli reporter active \
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli reporter active --host 127.0.0.1 --port 3030
```

### Activate Reporter

**Orakl Network Reporter** 서비스 시작 후 영구적인 reporter 상태에 추가된 리포터들은 기본적으로 비활성화 상태입니다. 비활성화된 reporter는 `reporter activate` command에 `--id` 매개변수를 사용하여 활성화할 수 있습니다. Reporter 식별자는 [`reporter list` command](reporter.md#list-reporters)을 통해 확인할 수 있습니다. Reporter 활성 상태가 되면 요청된 트랜잭션을 체인에 제출할 수 있습니다.

```sh
orakl-cli reporter activate \
    --id ${id}
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli reporter activate --id 15 --host 127.0.0.1 --port 3030
```

### Deactivate Reporter

활성화된 reporter의 **Orakl Network Reporter** 서비스에 필요한 리소스에 영향을 주지 않습니다. 그러나 가끔씩 활성화된 reporter 중 일부를 비활성화해야 할 수도 있습니다. Reporter를 비활성화하려면 `reporter deactivate` 명령을 사용하면 됩니다.&#x20;

```sh
orakl-cli reporter deactivate \
    --id ${id}
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli reporter deactivate --id 15 --host 127.0.0.1 --port 3030
```

> 만약 장기적으로 reporter를 사용하지 않는다면,[영구적인 reporter 상태에서 제거](reporter.md#remove-reporter-specified-by-id)해야 합니다. 그렇지 않으면 **Orakl Network Reporter** 가 재시작된 후에 활성화될 수 있습니다.

### Refresh Reporters

가끔은 영구적인 reporter 상태를 임시 reporter 상태와 동기화하는 것이 더 빠를 수 있습니다. 임시 reporter 상태를 영구 reporter 상태와 동일하게 설정해야 할 경우, `reporter refresh` 명령을 사용할 수 있습니다.

```sh
orakl-cli reporter refresh \
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli reporter refresh --host 127.0.0.1 --port 3030
```

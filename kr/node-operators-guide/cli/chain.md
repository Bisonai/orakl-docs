---
description: List, Insert And Remove Orakl Network Chains
---

# Chain

Orakl Network의 상태는 여러 체인에 대한 배포 정보를 포함할 수 있습니다. 체인은 모든 다른 Orakl Network 설정에서 사용되는 기본 구성입니다.

**Orakl Network CLI** 는 다음과 같은 command를 제공합니다

- [List Chains](chain.md#list-chains)
- [Insert New Chain](chain.md#insert-new-chain)
- [Remove Chain Specified By `id`](chain.md#remove-chain-specified-by-id)

### List Chains

```sh
orakl-cli chain list
```

```json
[
  { "id": 1, "name": "localhost" },
  { "id": 2, "name": "baobab" },
  { "id": 3, "name": "cypress" }
]
```

### Insert New Chain

체인이 설정되어 있지 않은 경우, **Orakl Network CLI** 의 `chain insert` 명령을 사용하여 새로운 체인을 추가할 수 있습니다.

```sh
orakl-cli chain insert \
    --name ${chainName}
```

### Remove Chain Specified By `id`

아직 체인에 연결된 항목이 없는 경우 체인을 제거할 수 있습니다.

```sh
orakl-cli chain remove \
    --id ${id}
```

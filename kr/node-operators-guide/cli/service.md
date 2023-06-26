---
description: List, Insert And Remove Orakl Network Services
---

# Service

Orakl Network은 여러 가지 솔루션을 제공하며, 각각의 솔루션은 고유한 구성 (예: 리스너 설정)을 가지고 있습니다. **Orakl Network CLI** 의 서비스 구성은 더 높은 수준의 솔루션 구성과 연결될 수 있는 임의의 서비스를 정의할 수 있도록 해줍니다.

**Orakl Network CLI** 는 다음과 같은 command를 제공합니다:

- [List Services](service.md#list-all-services)
- [Insert New Service](service.md#insert-new-service)
- [Remove Service Specified By `id`](service.md#remove-service-specified-by-id)

### List all services

Orakl Network 상태에 등록된 모든 서비스를 확인하려면 아래 command를 실행하세요.

```sh
orakl-cli service list
```

서비스를 모두 나열한 후의 예시 출력은 아래 목록에서 확인할 수 있습니다. 이 경우엔, 세 가지 서비스들이 있습니다: `VRF`, `DATA_FEED` 및 `REQUEST_RESPONSE`.

```json
[
  { "id": 1, "name": "VRF" },
  { "id": 2, "name": "DATA_FEED" },
  { "id": 3, "name": "REQUEST_RESPONSE" }
]
```

### Insert New Service

새로운 서비스 `service insert` 명령을 사용하여 Orakl Network 상태에 등록할 수 있습니다.

```sh
orakl-cli service insert \
    --name ${name}
```

### Remove Service Specified By `id`

다른 구성과 연결되지 않은 서비스는 서비스 `id` 를 사용하여 삭제할 수 있습니다.

```sh
orakl-cli service remove \
    --id ${id}
```

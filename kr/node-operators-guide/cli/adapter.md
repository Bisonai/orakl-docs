---
description: List, Insert And Remove Orakl Network Adapters
---

# Adapter

> 만약 **Orakl Network Data Feed Operator** 가 아니신 경우, 이 페이지의 설명을 참고하실 필요는 없습니다.

**Orakl Network CLI** 는 다음과 같은 command를 제공합니다:

- [List Adapters](adapter.md#list-adapters)
- [Insert New Adapter](adapter.md#add-new-adapter)
- [Remove Adapter Specified By `id`](adapter.md#remove-adapter-specified-by-id)

### What Is Adapter?

Adapter는 서로 다른 출처에서 오는 데이터 집합을 나타내는 추상화입니다. 이 데이터는 기본적으로 동일한 정보를 나타냅니다. 예를 들어, 여러 거래소에서 BTC의 가격이나 서울의 여러 위치에서 다른 센서로 측정된 온도 등이 있을 수 있습니다.

각 어댑터에는 어댑터 식별자인 `adapterHash`, `name`, `decimals` 및 `feeds` 속성이 있습니다. `adapterHash` 는 `adapterHash` 자체를 제외한 모든 어댑터 속성에서 계산되는 고유한 식별자입니다. 어댑터가 실수로 수정되지 않도록 하기 위해 안전을 위해 정의되었습니다. `name` 속성은 어댑터의 목적을 간결하게 설명합니다. `decimals` 속성은 어댑터에서 반환되는 값들이 인코딩된 소수점의 자릿수를 나타냅니다. `feeds` 속성은 가장 중요한 속성입니다. 이는 다양한 데이터 소스의 목록을 포함하며, 각 데이터 포인트가 어떻게 후처리되어야 하는지를 정의합니다.

Binance를 단일 데이터 소스로 사용하고 소수점 8 `자리`인 BTC-USD용 어댑터의 예입니다.

```sh
{
  "adapterHash": "0xe63985ed9d9aae887bdcfa03b53a1bea6fd1acc58b8cd51a9a69ede43eac6235",
  "name": "BTC-USD",
  "decimals": 8,
  "feeds": [
    {
      "name": "Binance-BTC-USD",
      "definition": {
        "url": "https://api.binance.us/api/v3/ticker/price?symbol=BTCUSD",
        "headers": {
          "Content-Type": "application/json"
        },
        "method": "GET",
        "reducers": [
          {
            "function": "PARSE",
            "args": [
              "price"
            ]
          },
          {
            "function": "POW10",
            "args": 8
          },
          {
            "function": "ROUND"
          }
        ]
      }
    }
  ]
}
```

### List Adapters

모든 등록된 어댑터는 `adapter list` command로 나열할 수 있습니다. 특정 체인의 어댑터만 보고 싶은 경우 `--chain` 매개변수를 사용할 수 있습니다.

```sh
orakl-cli adapter list \
    [--chain ${chain}]
```

### Insert New Adapter

여러 데이터 소스가 있는 경우, 어댑터 정의는 상당히 길어질 수 있습니다. 이러한 이유로, 로컬 컴퓨터에 있는 JSON 어댑터 파일이나 웹에서 호스팅되는 JSON 어댑터 파일로 `--source` 매개변수를 통해 새로운 어댑터를 등록할 수 있습니다.

[Orakl Network 데이터 피드 구성 페이지](https://config.orakl.network/) 에서 미리 정의된 어댑터 정의를 사용할 수 있습니다.

```sh
orakl-cli adapter insert \
    --source ${pathOrUrlToAdapterJsonFile}
```

- example

```sh
orakl-cli adapter insert --source https://config.orakl.network/adapter/baobab/dai-usdt.adapter.json
```

### Remove Adapter Specified By `id`

어댑터가 어떤 aggregator와도 연결되어 있지 않은 경우 해당 어댑터를 제거할 수 있습니다. 어댑터를 제거하려면 어댑터의 `id`를 지정하고 `adapter remove` command&#x20;에 `--id` 매개변수를 적용하면 됩니다.

```sh
orakl-cli adapter remove \
    --id ${id}
```

- example

```sh
orakl-cli adapter remove --id 15
```

---
description: Pull-based oracle submission using Data Availability Layer API
---

# Data Availability Layer API (DAL)

The on-chain price data can be updated on-demand by a user through the pull-based oracle. Off-chain price data are updated at sub-second intervals. Users with valid API key can access and [submit the latest price data on-chain](data-availability-layer-api.md#on-chain-price-data-submission). The price data can be either accessed through [REST API](data-availability-layer-api.md#rest-api) or [WebSocket API](data-availability-layer-api.md#websocket-api).

The DAL API requires the `X-API-Key` header. Please [contact us](mailto:business@orakl.network) to receive a valid API key.

## Basic Return Types


| Property      | Type   | Explanation         |
| ------------- | ------ | ------------------- |
| symbol        | string | symbol name         |
| value         | string | price value         |
| aggregateTime | string | timestamp value     |
| proof         | string | proof hexstring     |
| feedHash      | string | feed hash hexstring |
| decimals      | string | decimals            |

### Rest API

* Testnet (REST): [https://dal.baobab.orakl.network](https://dal.baobab.orakl.network)
* Mainnet (REST): [https://dal.cypress.orakl.network](https://dal.cypress.orakl.network)

### GET `/symbols`

returns supported symbols

<details>

<summary>Example Request</summary>

```bash
curl --location --request GET 'https://dal.baobab.orakl.network/symbols' \
--header 'X-API-Key: $API_KEY' \
--header 'Content-Type: application/json'
```

</details>

<details>

<summary>Example Response</summary>

```bash
[
"WAVES-KRW",
"BTC-USDT",
"CHF-USD",
"DAI-USDT",
"JOY-USDT",
"PAXG-USDT",
"GBP-USD",
"WEMIX-USDT",
"ATOM-USDT",
"DOGE-USDT",
"KSP-KRW",
"LTC-USDT",
"TRX-USDT",
"EUR-USD",
"JPY-USD",
"MNR-KRW",
"USDC-USDT",
"XRP-KRW",
"BNB-USDT",
"ETH-KRW",
"ETH-USDT",
"MBX-KRW",
"PER-KLAY",
"BLAST-KRW",
"BTC-KRW",
"DOT-USDT",
"FTM-USDT",
"ZRO-KRW",
"USDT-KRW",
"XRP-USDT",
"AVAX-USDT",
"BORA-KRW",
"KRW-USD",
"SOL-USDT",
"UNI-USDT",
"PEPE-USDT",
"SHIB-USDT",
"SOL-KRW",
"ADA-USDT",
"AKT-KRW",
"KLAY-USDT",
"MATIC-USDT",
"ONDO-KRW"
]
```

</details>

### GET `/latest-data-feeds/all`

returns latest submission parameters for all supported pairs

<details>

<summary>Example Request</summary>

```bash
curl --location --request GET 'https://dal.baobab.orakl.network/latest-data-feeds/all' \
--header 'X-API-Key: $API_KEY' \
--header 'Content-Type: application/json'
```

</details>

<details>

<summary>Example Response</summary>

```bash
[
    {
        "symbol": "BTC-USDT",
        "value": "6426575817343",
        "aggregateTime": "1721886857",
        "proof": "0x6cb90489dddc93c376425355cb497353695e53d91a7d61c3f1e122b1e5c0e2367dc95d36f40d5960784250008ed4a9f18d75b189f0d72eb9e2564e0a05ad374a1c",
        "feedHash": "0xa92bcb5bc51aa5535ed0cc3f522992dd9a6fb2e8dd6dcf484705d93eb3cd167a",
        "decimals": "8"
    },
    {
        "symbol": "ETH-USDT",
        "value": "318659264245",
        "aggregateTime": "1721886857",
        "proof": "0xd7c13dd825dd112de3ce52f704514d60c41f6d34bea3be13fc44a46394376ebd3947bdcb8d8dec9ae2959d1992b99220d4bf60988c7482b9ee98d3079199096b1b",
        "feedHash": "0x7020b52841bb268cbc78137a54d4bf1f5305eed1039fb5d003ba95b8ededc46c",
        "decimals": "8"
    }
    ...
]
```

</details>

### GET `/latest-data-feeds/{symbol,symbol,...}`

returns the latest submission parameters for requested pairs

<details>

<summary>Example Request</summary>

```bash
curl --location --request GET 'https://dal.baobab.orakl.network/latest-data-feeds/btc-usdt,eth-usdt' \
--header 'X-API-Key: $API_KEY' \
--header 'Content-Type: application/json'
```

</details>

<details>

<summary>Example Response</summary>

```bash
[
    {
        "symbol": "BTC-USDT",
        "value": "6426575817343",
        "aggregateTime": "1721886857",
        "proof": "0x6cb90489dddc93c376425355cb497353695e53d91a7d61c3f1e122b1e5c0e2367dc95d36f40d5960784250008ed4a9f18d75b189f0d72eb9e2564e0a05ad374a1c",
        "feedHash": "0xa92bcb5bc51aa5535ed0cc3f522992dd9a6fb2e8dd6dcf484705d93eb3cd167a",
        "decimals": "8"
    },
    {
        "symbol": "ETH-USDT",
        "value": "318659264245",
        "aggregateTime": "1721886857",
        "proof": "0xd7c13dd825dd112de3ce52f704514d60c41f6d34bea3be13fc44a46394376ebd3947bdcb8d8dec9ae2959d1992b99220d4bf60988c7482b9ee98d3079199096b1b",
        "feedHash": "0x7020b52841bb268cbc78137a54d4bf1f5305eed1039fb5d003ba95b8ededc46c",
        "decimals": "8"
    }
]
```

</details>

## WebSocket API

Testnet (WS): [ws://dal.baobab.orakl.network/ws](ws://dal.baobab.orakl.network/ws)

Mainnet (WS): [ws://dal.cypress.orakl.network/ws](ws://dal.cypress.orakl.network/ws)

### Connect and Request `/ws`

subscribes and pushes price feeds

<details>

<summary>Example Request</summary>

```bash
# connect
websocat ws://dal.baobab.orakl.network/ws -H "X-API-Key: $API_KEY"
# subscribe
{
  "method": "SUBSCRIBE",
  "params": [
    "submission@BTC-USDT"
  ]
}
```

</details>

<details>

<summary>Example Response</summary>

```bash
{
        "symbol": "BTC-USDT",
        "value": "6426575817343",
        "aggregateTime": "1721886857",
        "proof": "0x6cb90489dddc93c376425355cb497353695e53d91a7d61c3f1e122b1e5c0e2367dc95d36f40d5960784250008ed4a9f18d75b189f0d72eb9e2564e0a05ad374a1c",
        "feedHash": "0xa92bcb5bc51aa5535ed0cc3f522992dd9a6fb2e8dd6dcf484705d93eb3cd167a",
        "decimals": "8"
}
```

</details>

## On-chain Price Data Submission

The price data is submitted on-chain through [SubmissionProxy](https://github.com/Bisonai/orakl/blob/master/contracts/v0.2/src/SubmissionProxy.sol) contract. The contract address can be found at [JSON configuration](https://raw.githubusercontent.com/Bisonai/orakl/master/contracts/v0.2/addresses/others-addresses.json).

### `submit` function

#### Signature

```solidity
function submit(
    bytes32[] calldata _feedHashes,
    int256[] calldata _answers,
    uint256[] calldata _timestamps,
    bytes[] calldata _proofs
)
```

#### ABI

```json
[
  {
    "type": "function",
    "name": "submit",
    "inputs": [
      {
        "name": "_feedHashes",
        "type": "bytes32[]",
        "internalType": "bytes32[]"
      },
      {
        "name": "_answers",
        "type": "int256[]",
        "internalType": "int256[]"
      },
      {
        "name": "_timestamps",
        "type": "uint256[]",
        "internalType": "uint256[]"
      },
      {
        "name": "_proofs",
        "type": "bytes[]",
        "internalType": "bytes[]"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  }
]
```

### submitStrict

Submits in bulk with strict checks.
If one of the submission entry fails, the whole tx will fail with error

- signature

```solidity
function submitStrict(
        bytes32[] calldata _feedHashes,
        int256[] calldata _answers,
        uint256[] calldata _timestamps,
        bytes[] calldata _proofs
    )
```

- abi

```json
[
  {
    "type": "function",
    "name": "submitStrict",
    "inputs": [
      {
        "name": "_feedHashes",
        "type": "bytes32[]",
        "internalType": "bytes32[]"
      },
      { "name": "_answers", "type": "int256[]", "internalType": "int256[]" },
      {
        "name": "_timestamps",
        "type": "uint256[]",
        "internalType": "uint256[]"
      },
      { "name": "_proofs", "type": "bytes[]", "internalType": "bytes[]" }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  }
]
```

### submitSingle

Submits single entry with checks.

- signature

```solidity
function submitSingle(bytes32 _feedHash, int256 _answer, uint256 _timestamp, bytes calldata _proof)
```

- abi

```json
[
  {
    "type": "function",
    "name": "submitSingle",
    "inputs": [
      { "name": "_feedHash", "type": "bytes32", "internalType": "bytes32" },
      { "name": "_answer", "type": "int256", "internalType": "int256" },
      { "name": "_timestamp", "type": "uint256", "internalType": "uint256" },
      { "name": "_proof", "type": "bytes", "internalType": "bytes" }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  }
]
```

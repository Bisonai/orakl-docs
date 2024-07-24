---
description: Integrate pull based oracle through Data Availability Layer API
---

# Pull Oracle

Through the pull-based oracle, price data can be updated on-chain on demand by the user. Off-chain price data, which is updated at subsecond intervals, can be accessed and submitted to the chain on demand.

## API Endpoint

- Testnet (REST): https://dal.baobab.orakl.network
- Mainnet (REST): https://dal.cypress.orakl.network

The API requires the `X-API-Key` header for both REST API calls and WebSocket connections. Please [contact us](mailto:business@orakl.network) to receive a valid API key.

## Basic Return Types

It mostly returns a list of the following types:

| Property      | Type     | Explanation     |
| ------------- | -------- | --------------- |
| symbol        | string   | symbol name     |
| value         | string   | price value     |
| aggregateTime | string   | timestamp value |
| proof         | []byte   | proof value     |
| feedHash      | [32]byte | feed hash       |
| decimals      | string   | decimals        |

## Rest API

### Get `/symbols`

returns supported symbols

<details>
<summary>Example Request</summary>

```bash
curl --location --request GET 'https://dal.baobab.orakl.network/symbols' \
--header 'X-API-Key: {API_KEY}' \
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

### Get `/latest-data-feeds/all`

returns latest submission parameters for all supported pairs

<details>
<summary>Example Request</summary>

```bash
curl --location --request GET 'https://dal.baobab.orakl.network/latest-data-feeds/all' \
--header 'X-API-Key: {API_KEY}' \
--header 'Content-Type: application/json'
```

</details>

<details>
<summary>Example Response</summary>

```bash
[
    {
        "symbol": "ETH-KRW",
        "value": "434873384238632",
        "aggregateTime": "1720502320",
        "proof": "hIBaILTldU/NcO7bdGg3s9bYJJGGch9z12wTzb48NgRruG4o8ZwQB/G02IXXfqXFDN/vIaSIKjZkumkC/wFoDxw=",
        "feedHash": [
            109,
            228,
            175,
            7,
            68,
            71,
            200,
            53,
            75,
            5,
            212,
            84,
            124,
            56,
            45,
            47,
            1,
            39,
            219,
            146,
            222,
            219,
            81,
            64,
            232,
            208,
            65,
            78,
            51,
            202,
            85,
            162
        ],
        "decimals": "8"
    },
    ...
    {
        "symbol": "KSP-KRW",
        "value": "21498587636",
        "aggregateTime": "1720502320",
        "proof": "JpIGVaK5VR8ij92zn5p0SAOH0WpAHTWm/ESj9yLG3vRFeU3IbsvgRtajCwLc3MFpPm59Xi7xNzGTXPJ7CnuTABw=",
        "feedHash": [
            191,
            17,
            120,
            4,
            160,
            246,
            96,
            18,
            135,
            203,
            130,
            165,
            225,
            162,
            195,
            15,
            31,
            52,
            12,
            105,
            114,
            248,
            162,
            17,
            98,
            54,
            204,
            148,
            221,
            39,
            43,
            93
        ],
        "decimals": "8"
    }
]
```

</details>

### Get `/latest-data-feeds/{symbol, symbol, ..}`

returns latest submit parameters for certain pairs

<details>
<summary>Example Request</summary>

```bash
curl --location --request GET 'https://dal.baobab.orakl.network/latest-data-feeds/btc-usdt,eth-usdt' \
--header 'X-API-Key: {API_KEY}' \
--header 'Content-Type: application/json'
```

</details>

<details>
<summary>Example Response</summary>

```bash
[
	{
	    "symbol": "BTC-USDT",
	    "value": "5732493376201",
	    "aggregateTime": "1720502681",
	    "proof": "rrKHt0lgnbPq8LFzTovUp3pT+JIKliaDclaH6wR5d/80u8DxftgiuU/BNqci9tZZ3O2gq8RSibLSQ8O0QLvoTBw=",
	    "feedHash": [
	        169,
	        43,
	        203,
	        91,
	        197,
	        26,
	        165,
	        83,
	        94,
	        208,
	        204,
	        63,
	        82,
	        41,
	        146,
	        221,
	        154,
	        111,
	        178,
	        232,
	        221,
	        109,
	        207,
	        72,
	        71,
	        5,
	        217,
	        62,
	        179,
	        205,
	        22,
	        122
	    ],
	    "decimals": "8"
	},
	{
      "symbol": "ETH-USDT",
      "value": "337325575986",
      "aggregateTime": "1721120187",
      "proof": "kxGqISsT+2Y40sW2EdTA2mOjVvrCsoSjtb85dnUEGBtdRpVLGgXp0kE2b7XW9dkz0JQffJgjkiJFFT7N24g44Rs=",
      "feedHash": [
        112,
        32,
        181,
        40,
        65,
        187,
        38,
        140,
        188,
        120,
        19,
        122,
        84,
        212,
        191,
        31,
        83,
        5,
        238,
        209,
        3,
        159,
        181,
        208,
        3,
        186,
        149,
        184,
        237,
        237,
        196,
        108
      ],
      "decimals": "8"
    }
]
```

</details>

## Websocket

Websocket endpoints are as followed

Testnet: ws://dal.baobab.orakl.network/ws
Mainnet: ws://dal.cypress.orakl.network/ws

### Subscribe

```bash
{
   "method":"SUBSCRIBE",
   "params":[
      "submission@BTC-USDT",
      "submission@ETH-USDT",
      ...
   ]
}
```

### Pushed Data

```bash
{
  "symbol": "BTC-USDT",
  "value": "60000",
  "aggregateTime": "1719472582",
  "proof": "123",
  "feedHash": [...],
  "decimals": "8"
}
```

<details>
<summary>Example Request</summary>

```bash
# connect
websocat ws://dal.baobab.orakl.network/ws -H "X-API-Key:{API_KEY}"
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
  "value": "5732860170908",
  "aggregateTime": "1720502960",
  "proof": "zAeZ0QqHGa30fFZsOWAZbP2WmfuEU6ZYsbQxwYVwHFIdkE3bozpBmCbzEz4UmQFZhioAKMgEiJedTXSjq3vhDxw=",
  "feedHash": [
    169,
    43,
    203,
    91,
    197,
    26,
    165,
    83,
    94,
    208,
    204,
    63,
    82,
    41,
    146,
    221,
    154,
    111,
    178,
    232,
    221,
    109,
    207,
    72,
    71,
    5,
    217,
    62,
    179,
    205,
    22,
    122
  ],
  "decimals": "8"
}
{
  "symbol": "BTC-USDT",
  "value": "5733252415338",
  "aggregateTime": "1720502960",
  "proof": "KL5Xaw4D0eg4MaQ/E/WSB0aJITMMGlBqilDIA1dAWXYn+sY9Ybn8hOXuq6XcIhs9VghsCptzikq+Cx7a5dssURs=",
  "feedHash": [
    169,
    43,
    203,
    91,
    197,
    26,
    165,
    83,
    94,
    208,
    204,
    63,
    82,
    41,
    146,
    221,
    154,
    111,
    178,
    232,
    221,
    109,
    207,
    72,
    71,
    5,
    217,
    62,
    179,
    205,
    22,
    122
  ],
  "decimals": "8"
}
```

</details>

## Submit Price Onchain

The price data is submitted on-chain through contract [SubmissionProxy](https://github.com/Bisonai/orakl/blob/master/contracts/v0.2/src/SubmissionProxy.sol). And contract address can be found [here](https://raw.githubusercontent.com/Bisonai/orakl/master/contracts/v0.2/addresses/others-addresses.json)

### Function

- signature

```solidity
function submit(
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

There is no restriction for `msg.sender`, make a function call with parameters received through api.

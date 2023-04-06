---
description: List, Insert And Remove Orakl Network Adapters
---

# Adapter

> If you are not an **Orakl Network Data Feed Operator**, you do not need to read the explanation on this page.

The **Orakl Network CLI** provides commands to

* [List Adapters](adapter.md#list-adapters)
* [Insert New Adapter](adapter.md#add-new-adapter)
* [Remove Adapter Specified By `id`](adapter.md#remove-adapter-specified-by-id)

### What Is Adapter?

Adapter is an abstraction for a set of data coming from different sources but representing the same underlying information (e.g. price of BTC in various exchanges or temperature in Seoul measured wit different sensors at various locations across the city).

Every adapter has `adapterHash`, `name`, `decimals` and `feeds` property. `adapterHash` is a unique adapter identifier that is computed from all adapter properties except the `adapterHash` itself. It is defined for safety reasons so nobody can accidentally modify the adapter without anybody noticing. `name` property concisely describes the purpose of adapter. `decimals` property represents a number of decimal points in which the values returned from adapter are encoded. The values extracted from `feeds` are stored in an `integer` format and decimal points are stored separately. `feeds` property is the most important one. It contains a list of various data sources and defines how each data point should be post-processed.

The example of adapter for `BTC-USD` with a Binance as a single data source and 8 `decimals`.

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

All registered adapters can be listed with `adapter list` command. If you want to see only adapters for a specific chain, you can use the `--chain` parameter.

```sh
orakl-cli adapter list \
    [--chain ${chain}]
```

### Insert New Adapter

Adapter definition can become quite lengthy when there is more than one data source. For this reason we support the registration of new adapter through the `--source` parameter which can point to the JSON adapter file on your local computer, or to JSON adapter file hosted on web.

You can use predefined adapter definitions from the [Orakl Network Data Feed Configuration page](https://bisonai.github.io/orakl-config/).

```sh
orakl-cli adapter insert \
    --source ${pathOrUrlToAdapterJsonFile}
```

### Remove Adapter Specified By `id`

Adapter that is not associated with any aggregator can be removed. The adapter to remove is specified by its `id`. To remove adapter apply an `--id` parameter to `adapter remove` command.&#x20;

```sh
orakl-cli adapter remove \
    --id ${id}
```

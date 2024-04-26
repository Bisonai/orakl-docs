---
description: List, Insert And Remove Orakl Network Aggregators
---

# Aggregator

> If you are not an **Orakl Network Data Feed Operator**, you do not need to read the explanation on this page.

The **Orakl Network CLI** provides commands to

- [List Aggregators](aggregator.md#list-aggregators)
- [List Active Aggregators](aggregator.md#list-active-aggregators)
- [Insert New Aggregator](aggregator.md#insert-new-aggregator)
- [Remove Aggregator Specified By `id`](aggregator.md#remove-aggregator-specified-by-id)
- [Activate Aggregator](aggregator.md#activate-aggregator)
- [Deactivate Aggregator](aggregator.md#deactivate-aggregator)

### What Is Aggregator?

Aggregator is a an abstraction for the **Orakl Network Data Feed** solution. Every aggregator has an adapter assigned via `adapterHash`, and for each data feed it additionally defines the minimum update frequency through `heartbeat` property. Data feed is monitored with the **Orakl Network Fetcher** to detect any deviations above a predefined `threshold` or `absoluteThreshold`, in case the value of data feed has lower bound which was reached. `address` property specifies where the aggregated data feed values get updated.

The example of aggregator for `BTC-USD` data feed that is updated at least every 15 seconds on chain.

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

All registered aggregators can be listed with `aggregator list` command. If you want to see only aggregators for a specific chain, you can use the `--chain` parameter.

```sh
orakl-cli aggregator list \
    --chain ${chain}
```

- example

```sh
orakl-cli aggregator list --chain baobab
```

### List Active Aggregators

Aggregators displayed with `aggregator list` command are stored in a permanent storage of the **Orakl Network**. When the **Orakl Network Data Feed Worker** is launched, all aggregators are duplicated to ephemeral storage. To see all active aggregators use `aggregator active` command.

The command requires two optional parameters `--host` and `--port` which describe watchman's host and port of **Orakl Network Data Feed Worker**, respectively. The values can be predefined through `WORKER_SERVICE_HOST` and `WORKER_SERVICE_PORT` environment variables.

```bash
orakl-cli aggregator active \
    [--host ${DATA_FEED_WORKER_HOST}] \
    [--port ${DATA_FEED_WORKER_PORT}]
```

- example

```sh
orakl-cli aggregator active --host http://127.0.0.1 --port 5050
```

### Insert New Aggregator

Same as with adapters, aggregator definitions can become quite lengthy. For this reason we support the registration of new a new aggregator through the `--source` parameter which can point to the JSON aggregator file on your local computer, or to JSON aggregator file hosted on web. Additionally, you must specify a `chain` to which we associate the newly added aggregator.

You can use predefined aggregator definitions from the [Orakl Network Data Feed Configuration page](https://config.orakl.network/).

Aggregators added using `aggregator insert` command will not be recognized by the **Orakl Network Data Feed Worker** unless the service is restarted. If you want to launch new aggregator while the service is already running you need to [activate aggregator](aggregator.md#activate-aggregator) after it is inserted.

```sh
orakl-cli aggregator insert \
    --source ${pathOrUrlToAggregatorJsonFile} \
    --chain ${chain}
```

- example

```sh
orakl-cli aggregator insert --source https://config.orakl.network/aggregator/baobab/atom-usdt.aggregator.json --chain baobab
```

### Remove Aggregator Specified By `id`

The aggregator can be removed from the **Orakl Network** state only when it is inactive. Inactive aggregators can be removed with the `aggregator remove` command supplied with an extra `--id` parameter that represents an identifier of the aggregator.

```sh
orakl-cli aggregator remove \
    --id ${id}
```

- example

```sh
orakl-cli aggregator remove --id 15
```

### Activate Aggregator

Once the **Orakl Network Data Feed Worker** is already running, it is not enough to use `aggregator insert` command which modifies only Orakl Network's permanent storage. You need to transfer aggregator's definition from permanent to ephemeral storage. To activate aggregator on running **Orakl Network Data Feed Worker** service, use `aggregator activate` command.

The command requires two optional parameters `--host` and `--port` which describe watchman's host and port of **Orakl Network Data Feed Worker**, respectively. The values can be predefined through `WORKER_SERVICE_HOST` and `WORKER_SERVICE_PORT` environment variables.

```bash
orakl-cli aggregator activate \
    --aggregatorHash ${aggregatorHash} \
    [--host ${DATA_FEED_WORKER_HOST}] \
    [--port ${DATA_FEED_WORKER_PORT}]
```

- example

```sh
orakl-cli aggregator activate --aggregatorHash 0x12 --host 127.0.0.1 --port 5050
```

### Deactivate Aggregator

When the **Orakl Network Data Feed Worker** is running and you need to stop some of the data feeds, use `aggregator deactivate` command. This command will remove a single aggregator defined by `aggregatorHash` from ephemeral storage, and it will not have any effect on other active data feeds.

The command requires two optional parameters `--host` and `--port` which describe watchman's host and port of **Orakl Network Data Feed Worker**, respectively. The values can be predefined through `WORKER_SERVICE_HOST` and `WORKER_SERVICE_PORT` environment variables.

```bash
orakl-cli aggregator deactivate \
    --aggregatorHash ${aggregatorHash} \
    [--host ${DATA_FEED_WORKER_HOST}] \
    [--port ${DATA_FEED_WORKER_PORT}]
```

- example

```sh
orakl-cli aggregator deactivate --aggregatorHash 0x12 --host 127.0.0.1 --port 5050
```

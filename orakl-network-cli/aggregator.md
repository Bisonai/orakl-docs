---
description: List, insert and remove Orakl Network aggregators
---

# Aggregator

> If you are not an **Orakl Network Data Feed Operator**, you do not need to read the explanation on this page.

The **Orakl Network CLI** provides commands to

* [List Aggregators](aggregator.md#list-aggregators)
* [Insert New Aggregator](aggregator.md#insert-new-aggregator)
* [Remove Aggregator Specified By `id`](aggregator.md#remove-aggregator-specified-by-id)``

### What Is Aggregator?

Aggregator is a an abstraction for the **Orakl Network Data Feed** solution. Every aggregator has an adapter assigned via `adapterHash`, and for such data feed it additionally defines the minimum update frequency through `heartbeat` property. Data feed is monitored with the **Orakl Network Fetcher** to detect any deviations above a predefined `threshold` or `absoluteThreshold`, in case the value of data feed has lower limit and the limit was reached. `address` property specifies where the aggregated data feed values get updated.

The example of aggregator for `BTC-USD` data feed that is updated at least every 15 seconds to on-chain.

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

### Insert New Aggregator

Same as with adapters, aggregator definitions can become quite lengthy. For this reason we support the registration of new a new aggregator through the `--file-path` parameter which points to the JSON file with aggregator definition. Additionally, we must specify a `chain` to which we associate the newly added aggregator.

```sh
orakl-cli aggregator insert \
    --file-path ${aggregatorJsonFile} \
    --chain ${chain}
```

### Remove Aggregator Specified By `id`&#x20;

The aggregator can be removed from the Orakl Network state only when it is inactive. Inactive aggregators can be removed with the `aggregator remove` command supplied with an extra `--id` parameter that represents an identifier of the aggregator.

```sh
orakl-cli aggregator remove \
    --id ${id}
```

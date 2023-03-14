---
description: List, insert and remove Orakl Network aggregators
---

# Aggregator

The **Orakl Network CLI** provides commands to

* [List Aggregators](aggregator.md#list-aggregators)
* [Insert New Aggregator](aggregator.md#insert-new-aggregator)
* [Remove Aggregator Specified By `id`](aggregator.md#remove-aggregator-specified-by-id)``

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

### Remove aggregator Specified By `id`&#x20;

The aggregator can be removed from the Orakl Network state only when it is inactive. Inactive aggregators can be removed with the `aggregator remove` command supplied with an extra `--id` parameter that represents an identifier of the aggregator.

```sh
orakl-cli aggregator remove \
    --id ${id}
```

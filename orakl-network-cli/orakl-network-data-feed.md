---
description: Start And Stop Data Collection
---

# Orakl Network Data Feed

> If you are not an **Orakl Network Data Feed Operator**, you do not need to read the explanation on this page.

The **Orakl Network CLI** provides commands to

* [Start Single Data Feed Collection](orakl-network-data-feed.md#start-single-data-feed-collection)
* [Stop Single Data Feed Collection](orakl-network-data-feed.md#stop-single-data-feed-collection)

The **Orakl Network Fetcher** is used to regularly collect data based on the definitions in adapter. Collected and aggregated data are then available to the **Orakl Network Data Feed**. The Orakl Network Data Feed control mechanism is split into two distinct actions:

* Data Feed Collection
* Provisioning Of Data Feed To Aggregator

### Start Single Data Feed Collection

The **Orakl Network Fetcher** can start an immediate data collection for a registered aggregator with `fetcher start` command. An aggregator can be registered under multiple `chains` so we need to specify the appropriate chain through the `--chain` parameter as well.&#x20;

```sh
orakl-cli fetcher start \
    --id ${aggregatorhash} \
    --chain ${chainName}
```

### Stop Single Data Feed Collection

Data collection performed by the Orakl Network Fetcher can be stopped with `fetcher stop` command.

```sh
orakl-cli fetcher stop \
    --id ${aggregatorhash} \
    --chain ${chainName}
```

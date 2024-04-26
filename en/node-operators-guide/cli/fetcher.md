---
description: Start And Stop Data Collection
---

# Fetcher

> If you are not an **Orakl Network Data Feed Operator**, you do not need to read the explanation on this page.

The **Orakl Network CLI** provides commands to

- [List active aggregators](fetcher.md#list-active-aggregators)
- [Start Single Data Feed Collection](fetcher.md#start-single-data-feed-collection)
- [Stop Single Data Feed Collection](fetcher.md#stop-single-data-feed-collection)

The **Orakl Network Fetcher** is used to regularly collect data based on the definitions in adapter. Collected and aggregated data are available to the **Orakl Network Data Feed**.

### List Active Fetchers

The **Orakl Network Fetcher** can show the list of active Fetchers with `fetcher active` command.

```sh
orakl-cli fetcher active \
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli fetcher active --host http://127.0.0.1 --port 5050
```

### Start Single Data Feed Collection

The **Orakl Network Fetcher** can start an immediate data collection for a registered aggregator with `fetcher start` command. An aggregator can be registered under multiple `chains` so we need to specify the appropriate chain through the `--chain` parameter as well.

```sh
orakl-cli fetcher start \
    --id ${aggregatorhash} \
    --chain ${chainName} \
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli fetcher start --id 0x12 --chain baobab --host http://127.0.0.1 --port 3030
```

### Stop Single Data Feed Collection

Data collection performed by the Orakl Network Fetcher can be stopped with `fetcher stop` command.

```sh
orakl-cli fetcher stop \
    --id ${aggregatorhash} \
    --chain ${chainName} \
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli fetcher stop --id 0x12 --chain baobab --host http://127.0.0.1 --port 3030
```

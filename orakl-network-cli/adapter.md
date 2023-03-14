---
description: List, generate, insert and remove Orakl Network adapters
---

# Adapter

The **Orakl Network CLI** provides a commands to

* [List Adapters](adapter.md#list-adapters)
* [Insert New Adapter](adapter.md#add-new-adapter)
* [Remove Adapter Specified By `id`](adapter.md#remove-adapter-specified-by-id)``



### List Adapters

```
orakl-cli adapter list
```

List all adapters registered for `baobab` chain

```
npx orakl-cli adapter list --chain baobab
```

### Insert New Adapter

```
npx orakl-cli adapter insert --file-path [adapter-file] --chain baobab
```

### Remove Adapter Specified By `id`

Adapter that is not associated with any aggregator can be removed. The adapter to remove is specified by its `id`. To remove adapter apply an `--id` parameter to `adapter remove` command.&#x20;

```sh
npx orakl-cli adapter remove \
    --id ${id}
```

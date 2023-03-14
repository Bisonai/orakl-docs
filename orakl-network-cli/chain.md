---
description: List, insert and remove Orakl Network chains
---

# Chain

The Orakl Network state can hold information about deployments to multiple chains. The chain is a fundamental configuration which is used in all other Orakl Network settings.

The **Orakl Network CLI** provides a commands to

* [List Chains](chain.md#list-chains)
* [Insert New Chain](chain.md#insert-new-chain)
* [Remove Chain Specified By `id`](chain.md#remove-chain-specified-by-id)``

### List Chains

```sh
orakl-cli chain list
```

```json
[
  { id: 1, name: 'localhost' },
  { id: 2, name: 'baobab' },
  { id: 3, name: 'cypress' }
]
```

### Insert New Chain

If there are not chains set, we can add a new chain using `chain insert` command of the **Orakl Network CLI**.

```sh
orakl-cli chain insert \
    --name ${chainName}
```

### Remove Chain Specified By `id`

Chains can be removed when there are no association to them yet.

```sh
orakl-cli chain remove \
    --id ${id}
```

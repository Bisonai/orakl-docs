---
description: List, Insert, Remove, Activate And Deactivate Orakl Network Reporters
---

# Reporter

> If you are not an **Orakl Network Data Feed Operator**, you do not need to read the explanation on this page.

The **Orakl Network CLI** provides commands to

* [List Reporters](reporter.md#list-reporters)
* [Insert New Reporter](reporter.md#insert-new-reporter)
* [Remove Reporter Specified By `id`](reporter.md#remove-reporter-specified-by-id)``

### What Is Reporter?

Reporter is an abstraction for Externally Owned Account (EOA), as well as for an on-chain oracle that is associated with it. Reporter is allowed to make transactions only to the oracle specified by the address (`oracleAddress`) on a predefined `chain`. Reporters can be grouped according to the service they are assigned to.

Reporter metadata are used in all the Orakl Network Service (**Orakl Network Listener**, **Orakl Network Worker** and **Orakl Network Reporter**), therefore we recommend to setup reporters before running any of these services.

### List Reporters

All registered reporters can be listed with `reporter list` command. If you want to see only reporters for a specific chain or service, you can use the `--chain` parameter or `--service` parameter, respectively. Both `--chain` and `--service` parameters are optional.

```sh
orakl-cli reporter list \
    [--chain ${chain}] \
    [--service ${service}
```

### Insert New Reporter

To insert new reporter, one can use the `reporter insert` command. The command requires three groups of commands: EOA-related, oracle-related and category-related. EOA parameters (`--address` and `--privateKey`) are used to create wallet that creates and sends transaction to on-chain smart contract. Oracle parameter (`oracleAddress`) defines which smart contract can be executed by this reporter's wallet. The **Orakl Network** uses a single EOA for each smart contract in order to limit scalability issues when multiple transaction are issued from the same wallet around the same time. Lastly, category parameters (`--chain` and `--service`) are used to for reporter separation by chain and service, respectively.

```sh
orakl-cli reporter insert \
  --chain ${chain} \
  --service ${service} \
  --address ${address} \
  --privateKey ${privateKey} \
  --oracleAddress ${oracleAddress}
```

### Remove Reporter Specified By `id`

The reporter can be removed from the **Orakl Network** state anytime, however, it won't have an immediate impact on the ephemeral state of **Orakl Network**. If you need an immediate change inside of your **Orakl Network Reporter service**, use `reporter deactivate` command.

Reporter can be removed using the `reporter remove` command supplied with an extra `--id` parameter that represents an identifier of the reporter.

```sh
orakl-cli reporter remove \
    --id ${id}
```

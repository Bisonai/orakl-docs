---
description: List, Insert, Remove, Activate, Deactivate And Refresh Orakl Network Reporters
---

# Reporter

> If you are not an **Orakl Network Data Feed Operator**, you do not need to read the explanation on this page.

The **Orakl Network CLI** provides commands to modify both [permanent](reporter.md#permanent-state) or [ephemeral state](reporter.md#ephemeral-state) of **Orakl Network Reporter**. The list of supported actions is shown below:

* [List Reporters](reporter.md#list-reporters)
* [Insert New Reporter](reporter.md#insert-new-reporter)
* [Remove Reporter Specified By `id`](reporter.md#remove-reporter-specified-by-id)
* [List Active Reporters](reporter.md#list-active-reporters)
* [Activate Reporter](reporter.md#activate-reporter)
* [Deactivate Reporter](reporter.md#deactivate-reporter)
* [Refresh Reporters](reporter.md#refresh-reporters)

## What Is Reporter?

Reporter is an abstraction for Externally Owned Account (EOA), as well as for an on-chain oracle that is associated with it. Reporter is allowed to make transactions only to the oracle specified by the address (`oracleAddress`) on a predefined `chain` for a specific `service`.

Reporter metadata are used in all the **Orakl Network** services (**Orakl Network Listener**, **Orakl Network Worker** and **Orakl Network Reporter**).

## Permanent  State

The permanent state of reporter is loaded on launch of the **Orakl Network Reporter** service, and accessed on-demand from the **Orakl Network Listener** and the **Orakl Network Worker**.

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

## Ephemeral State

The ephemeral state of reporter is created during launch of the **Orakl Network Reporter** service, and is used throughout its lifetime until it terminates. All commands from the [Permanent State section](reporter.md#permanent-state) will not have affect on the ephemeral state unless you apply the `activate`, `deactivate` or `refresh` commands that are described below.

Unlike the permanent reporter state, the ephemeral reporter state is accessed through a watchman that runs inside of **Orakl Network Reporter** service. For this reason, every command that needs an access to ephemeral state has to specify a `--host` and a `--port` parameter that defines the location of the **Orakl Network Reporter** service in the network.

### List Active Reporters

All reporters that are part of the permanent state during the launch of the **Orakl Network Reporter** service are automatically made active, and can be listed with `reporter active` command. [Reporters that are later activated](reporter.md#activate-reporter) will be visible through this command as well. If reporter is not in an active state, it cannot send transaction to its assigned oracle.

```sh
orakl-cli reporter active \
    --host ${host} \
    --port ${port}
```

### Activate Reporter

Reporters that are added to the permanent reporter state after the launch of the **Orakl Network Reporter** service are inactive by default. Inactive reporters can be activated by the `reporter activate` command with `--id` parameter. The reporter identifier can be found through the [`reporter list` command](reporter.md#list-reporters). After reporter becomes active, it can start submitting requested transaction to the chain.

```sh
orakl-cli reporter activate \
    --id ${id}
    --host ${host} \
    --port ${port}
```

### Deactivate Reporter

The number of active reporter does not affect required resources for the **Orakl Network Reporter** service, however from time to time, you might need to deactivate some of your active reporters. To deactivate reporter, you can use `reporter deactivate` command.&#x20;

```sh
orakl-cli reporter deactivate \
    --id ${id}
    --host ${host} \
    --port ${port}
```

> If you do not want to use reporter long-term, you should [remove it from the permanent reporter state](reporter.md#remove-reporter-specified-by-id), otherwise it will become active after the **Orakl Network Reporter** restarts.

### Refresh Reporters

Sometimes, it might be faster to sync permanent reporter state with ephemeral reporter state. If you need to set ephemeral reporter state to the permanent one, you can use `reporter refresh` command.

```sh
orakl-cli reporter refresh \
    --host ${host} \
    --port ${port}
```

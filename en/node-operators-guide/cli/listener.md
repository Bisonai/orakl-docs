---
description: List, Inser, Remove, Activate And Deactivate Orakl Network Listeners
---

# Listener

The **Orakl Network Listener** is a microservice that is part of every Orakl Network solution (VRF, Request-Response and Aggregator). The listener configuration includes [`chain`](chain.md), [`service`](service.md), `address` and `eventName` property. The **Orakl Network Listener** listens for an event defined as `eventName` emitted from smart contract `address`.

The **Orakl Network CLI** provides commands to modify both [permanent](listener.md#permanent-state) or [ephemeral state](listener.md#ephemeral-state) of **Orakl Network Listener**. The list of supported actions is shown below:

- [List Listeners](listener.md#list-listeners)
- [Insert New Listener](listener.md#insert-new-listener)
- [Remove Listener Specified By `id`](listener.md#remove-listener-specified-by-id)
- [List Active Listeners](listener.md#list-active-listeners)
- [Activate Listener](listener.md#activate-listener)
- [Deactivate Listener](listener.md#deactivate-listener)

## Permanent State

The permanent state of listener is loaded on launch of the **Orakl Network Listener** service. It is not accessed by other services such as the **Orakl Network Worker** or the **Orakl Network Reporter**.

### List Listeners

Listeners kept in permanent state can be displayed with `listener list` command. You can filter the listeners by using optional parameters: [`--chain`](chain.md) or [`--service`](service.md) .

```sh
orakl-cli listener list \
    [--chain ${chain}] \
    [--service ${service}]
```

- example

```sh
orakl-cli listener list --chain baobab --service DATA_FEED
```

The example output of `listener list` command is displayed below. It includes three different listeners that should listen on three addresses for three different events: `RandomWordsRequested`, `NewRound` and `DataRequested`.

```json
[
  {
    "id": "1",
    "address": "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
    "eventName": "RandomWordsRequested",
    "service": "VRF",
    "chain": "baobab"
  },
  {
    "id": "2",
    "address": "0xa513E6E4b8f2a923D98304ec87F64353C4D5C853",
    "eventName": "NewRound",
    "service": "DATA_FEED",
    "chain": "baobab"
  },
  {
    "id": "3",
    "address": "0x45778c29A34bA00427620b937733490363839d8C",
    "eventName": "DataRequested",
    "service": "REQUEST_RESPONSE",
    "chain": "baobab"
  }
]
```

To list listeners associated with a specific chain, you can use the `--chain` parameter.

```sh
orakl-cli listener list \
    --chain ${chain}
```

- example

```sh
orakl-cli listener list --chain baobab
```

To list listeners associated with a specific service, you can use the `--service` parameter.

```sh
orakl-cli listener list \
    --service ${service}
```

- example

```sh
orakl-cli listener list --service VRF
```

### Insert New Listener

To insert a new listener to a permanent listener state, you can use the `listener insert` command.

```sh
orakl-cli listener insert \
    --chain ${chain} \
    --service ${service} \
    --address ${address} \
    --eventName ${eventName}
```

- example

```sh
orakl-cli listener insert --chain baobab --service VRF --address 0x123 --eventName RandomWordsRequested
```

### Remove Listener Specified By `id`

Listeners can be removed from a permanent listener state by the `listener remove` command. The listener to remove is specified by its identifier (`--id`).

```sh
orakl-cli listener remove \
    --id ${id}
```

- example

```sh
orakl-cli listener remove --id 72
```

## Ephemeral State

The ephemeral state of listener is created during launch of the **Orakl Network Listener** service, and is used throughout its lifetime until it terminates. All commands from the [Permanent State section](listener.md#permanent-state) will not have affect on the ephemeral state unless you apply the `activate` or `deactivate` commands that are described below.

Unlike the permanent listener state, the ephemeral listener state is accessed through a watchman that runs inside of **Orakl Network Listener** service. For this reason, every command that needs an access to ephemeral state has to specify a `--host` and a `--port` parameter that defines the location of the **Orakl Network Listener** service in the network.

### List Active Listeners

All listeners that are part of the permanent state during the launch of the **Orakl Network Listener** service are automatically made active, and can be listed with `listener active` command. [Listeners that are later activated](listener.md#activate-listener) will be visible through this command as well. If a listener is not in an active state, it does not listen to the event from its configuration.

```sh
orakl-cli listener active \
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli listener active --host http://127.0.0.1 --port 3030
```

### Activate Listener

Listeners that are added to the permanent listener state after the launch of the **Orakl Network Listener** service are inactive by default. Inactive listeners can be activated by the `listener activate` command with `--id` parameter. The listener identifier can be found through the [`listener list` command](listener.md#list-listeners). After a listener becomes active, it starts listening for the events defined in its configuration.

```sh
orakl-cli listener activate \
    --id ${id}
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli listener activate --host http://127.0.0.1 --port 3030
```

### Deactivate Listener

Every new active listener requires an extra computation resource, however, in general it operates with low overhead. When a listener spots an event for which it was listening for, it create a new job for the **Orakl Network Worker**, which then passes new job to the **Orakl Network Reporter**. The consequence of having an extra listener which we do need is an unnecessarily high load on the overall system.

To deactivate listener, and therefore to lower the load on the system, you can use `listener deactivate` command.&#x20;

```sh
orakl-cli listener deactivate \
    --id ${id}
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli listener deactivate --host http://127.0.0.1 --port 3030
```

> If you do not want to use listener long-term, you should [remove it from the permanent listener state](listener.md#remove-listener-specified-by-id), otherwise it will become active after the **Orakl Network Listener** restarts.

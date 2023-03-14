---
description: List, insert and remove Orakl Network listeners
---

# Listener

The **Orakl Network Listener** is a microservice that is part of every Orakl Network solution (VRF, Request-Response and Aggregator). The listener configuration includes [`chain`](chain.md), [`service`](service.md), `address` and `eventName` property. The **Orakl Network Listener** listens for an event defined as `eventName` emitted from smart contract `address`.

The **Orakl Network CLI** provides commands to

* [List Listeners](listener.md#list-listeners)
* [Insert New Listener](listener.md#insert-new-listener)
* [Remove Listener Specified By `id`](listener.md#remove-listener-specified-by-id)``

### List Listeners

All listeners can be displayed with `listener list` command. If you need more specific listing, you can use [`--chain`](chain.md) or [`--service`](service.md) optional parameters.

```sh
orakl-cli listener list \
    [--chain ${chain}] \
    [--service ${service}]
```

The example output of `listener list` command is displayed below. It includes three different listeners listening on three addressed for  various events: `RandomWordsRequested`, `NewRound` and `Requested`.

```json
[
  {
    address: '0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0',
    eventName: 'RandomWordsRequested'
  },
  {
    address: '0xa513E6E4b8f2a923D98304ec87F64353C4D5C853',
    eventName: 'NewRound'
  },
  {
    address: '0x45778c29A34bA00427620b937733490363839d8C',
    eventName: 'Requested'
  }
]
```

To list listeners associated with a specific chain, you can use the `--chain` parameter.

```sh
orakl-cli listener list \
    --chain ${chain}
```

To list listeners associated with a specific service, you can use the `--service` parameter.

```sh
orakl-cli listener list \
    --service ${service}
```

### Insert New Listener

To insert new listener, one can use the `listener insert` command.

```sh
orakl-cli listener insert \
    --chain ${chain} \
    --service ${service} \
    --address ${address} \
    --eventName ${eventName}
```

### Remove Listener Specified By `id`

Listeners can be removed based on their `id`, using the `--id` parameter applied to `listener remove` command.

```sh
orakl-cli listener remove \
    --id ${id}
```
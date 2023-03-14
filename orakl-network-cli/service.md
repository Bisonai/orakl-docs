---
description: List, insert and remove Orakl Network services
---

# Service

The Orakl Network offers several solutions, and each of them has its own specific configuration (e.g. listener setting). Service configuration in the **Orakl Network CLI**, allows to define an arbitrary services that can be associated with higher level solution configuration.

The **Orakl Network CLI** provides a commands to

* [List Services](service.md#list-all-services)
* [Insert New Service](service.md#insert-new-service)
* [Remove Service Specified By `id`](service.md#remove-service-specified-by-id)``

### List all services

To list all serviced registered in the Orakl Network state, run the command below.

```sh
orakl-cli service list
```

The example output after listing all services can be seen in the listing below. In this case, there are three services: `VRF`, `Aggregator` and `RequestResponse`.

```json
[
  { id: 1, name: 'VRF' },
  { id: 2, name: 'Aggregator' },
  { id: 3, name: 'RequestResponse' }
]
```

### Insert New Service

A new service can be registered to the Orakl Network state with `service insert` command.

```sh
orakl-cli service insert \
    --name Automation
```

### Remove Service Specified By `id`

Services that are not associated with any settings can be deleted based on the service `id`.

```sh
orakl-cli service remove \
    --id 4
```

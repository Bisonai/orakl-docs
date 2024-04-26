---
description: List, Insert And Remove Orakl Network Services
---

# Service

The Orakl Network offers several solutions, and each of them has its own specific configuration (e.g. listener setting). Service configuration in the **Orakl Network CLI**, allows to define an arbitrary services that can be associated with higher level solution configuration.

The **Orakl Network CLI** provides commands to

- [List Services](service.md#list-all-services)
- [Insert New Service](service.md#insert-new-service)
- [Remove Service Specified By `id`](service.md#remove-service-specified-by-id)

### List all services

To list all serviced registered in the Orakl Network state, run the command below.

```sh
orakl-cli service list
```

The example output after listing all services can be seen in the listing below. In this case, there are three services: `VRF`, `DATA_FEED` and `REQUEST_RESPONSE`.

```json
[
  { "id": 1, "name": "VRF" },
  { "id": 2, "name": "DATA_FEED" },
  { "id": 3, "name": "REQUEST_RESPONSE" }
]
```

### Insert New Service

A new service can be registered to the Orakl Network state with `service insert` command.

```sh
orakl-cli service insert \
    --name ${name}
```

- example

```sh
orakl-cli service insert --name VRF
```

### Remove Service Specified By `id`

Services that are not associated with any other configuration can be deleted given the service `id`.

```sh
orakl-cli service remove \
    --id ${id}
```

- example

```sh
orakl-cli service remove --id 15
```

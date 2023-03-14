# Service

The Orakl Network offers several solutions, and each of them has its own specific configuration (e.g. listener setting). Service configuration in the **Orakl Network CLI**, allows to define an arbitrary services that can be associated with higher level solution configuration.

The **Orakl Network CLI** provides a commands to

* [List Services](service.md#list-all-services)
* [Insert New Service](service.md#insert-new-service)
* [Remove Service Specified by `id`](service.md#remove-service-specified-by-id)``

### List all services

```sh
orakl-cli service list
```

```json
[
  { id: 1, name: 'VRF' },
  { id: 2, name: 'Aggregator' },
  { id: 3, name: 'RequestResponse' }
]
```

### Insert New Service

```sh
npx orakl-cli service insert \
    --name Automation
```

### Remove Service Specified By `id`

```sh
npx orakl-cli service remove \
    --id 4
```

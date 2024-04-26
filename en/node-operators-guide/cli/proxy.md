---
description: List, Insert And Remove Orakl Network Proxies
---

# Proxy

The **Orakl Network ** state can store information about the multiple proxies. Proxies are can be utilized to fetch data by making requests through defined proxy configurations.

The **Orakl Network CLI** provides commands to

- [List Proxies](proxy.md#list-proxies)
- [Insert New Proxy](proxy.md#insert-new-proxy)
- [Remove Proxy Specified By `id`](proxy.md#remove-proxy-specified-by-id)

### List Proxies

```sh
orakl-cli proxy list
```

```json
[
  { id: '1', protocol: 'http', host: '127.0.0.1', port: 80},
  { id: '1', protocol: 'http', host: '127.0.0.1', port: 88'},
]
```

### Insert New Proxy

Proxies can be added with a `proxy insert` command. A unique proxy can be added only once.

```sh
orakl-cli proxy insert \
    --protocol ${protocol} \
    --host ${host} \
    --port ${port}
```

- example

```sh
orakl-cli proxy insert --protocol http --host 127.0.0.1 --port 80
```

### Remove Proxy Specified By `id`

Proxies can be removed when there are no association to them yet.

```sh
orakl-cli proxy remove \
    --id ${id}
```

- example

```sh
orakl-cli proxy remove --id 15
```

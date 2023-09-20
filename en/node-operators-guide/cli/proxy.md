---
description: List, Insert And Remove Orakl Network Proxies
---

# Proxy

The Orakl Network state can hold information about deployments to multiple proxies. The proxy is a fundamental configuration which is used in all other Orakl Network settings.

The **Orakl Network CLI** provides commands to

* [List Proxies](proxy.md#list-proxies)
* [Insert New Proxy](proxy.md#insert-new-proxy)
* [Remove Proxy Specified By `id`](proxy.md#remove-proxy-specified-by-id)

### List Proxies

```sh
orakl-cli proxy list
```

```json
[
  { id: '1', protocol: 'http', host: '127.0.0.1', port: 80},
  { id: '1', protocol: 'http', host: '127.0.0.1', port: 88},
]
```

### Insert New Proxy

If there are not proxies set, we can add a new proxy using `proxy insert` command of the **Orakl Network CLI**.

```sh
orakl-cli proxy insert \
    --protocol ${protocol} \
    --host ${host} \
    --port ${port}
```

### Remove Proxy Specified By `id`

Proxies can be removed when there are no association to them yet.

```sh
orakl-cli proxy remove \
    --id ${id}
```

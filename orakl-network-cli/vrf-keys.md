---
description: List, generate, insert and remove Orakl Network VRF keys
---

# VRF Keys

> If you are not an **Orakl Network VRF Node Operator**, you do not need to read the explanation on this page.

The **Orakl Network VRF Worker** needs an access to a private VRF keys (`sk`) to produce a provably random number given the consumer seed (received from on-chain). The **Orakl Network VRF Listener** requires a key hash (`key_hash`) that uniquely represents VRF keys. Typically, an **Orakl Network VRF Node Operator** does not need more than a single set of VRF keys (`pk`, `sk`, `pk_x`, `pk_y` and `key_hash`).

The **Orakl Network CLI** provides a commands to

* [List VRF Keys](vrf-keys.md#list-vrf-keys)
* [Generate VRF Keys](vrf-keys.md#generate-vrf-keys)
* [Insert VRF Keys](vrf-keys.md#insert-vrf-keys)
* [Remove VRF Keys Specified By `id`](vrf-keys.md#remove-vrf-keys-specified-by-id)``

### List VRF Keys

All VRF keys registered in the Orakl Network state can be listed with a `vrf list` command.

```sh
orakl-cli vrf list
```

To display VRF keys that are associated with a specific chain, you can apply an additional `--chain` parameter.

```sh
orakl-cli vrf list \
    --chain localhost
```

### Generate VRF  Keys

VRF keys can be generated with `vrf keygen` command.

```sh
orakl-cli vrf keygen
```

The `vrf keygen` command produces an output similar to the one below. VRF key generation is random, therefore the output will change with every new run. `sk` represents a private key that should never be shared with anybody who you do not trust.&#x20;

```
sk=ebeb5229570725793797e30a426d7ef8aca79d38ff330d7d1f28485d2366de32
pk=045b8175cfb6e7d479682a50b19241671906f706bd71e30d7e80fd5ff522c41bf0588735865a5faa121c3801b0b0581440bdde24b03dc4c4541df9555d15223e82
pk_x=41389205596727393921445837404963099032198113370266717620546075917307049417712
pk_y=40042424443779217635966540867474786311411229770852010943594459290130507251330
key_hash=0x6f32373625e3d1f8f303196cbb78020ac2503acd1129e44b36b425781a9664ac
```

The `vrf keygen` command only generates VRF keys. If you want to use them in the **Orakl Network VRF**, you need to insert them to the Orakl Network state through `vrf insert` command.

### Insert VRF Keys

New VRF keys can be inserted using `vrf insert` command. The command below demonstrates how to insert VRF keys generatef by the `vrf keygen` command above and associate with `baobab` chain.

```sh
orakl-cli vrf insert \
    --sk ebeb5229570725793797e30a426d7ef8aca79d38ff330d7d1f28485d2366de32 \
    --pk 045b8175cfb6e7d479682a50b19241671906f706bd71e30d7e80fd5ff522c41bf0588735865a5faa121c3801b0b0581440bdde24b03dc4c4541df9555d15223e82 \
    --pk_x 41389205596727393921445837404963099032198113370266717620546075917307049417712 \
    --pk_y 40042424443779217635966540867474786311411229770852010943594459290130507251330 \
    --key_hash 0x6f32373625e3d1f8f303196cbb78020ac2503acd1129e44b36b425781a9664ac \
    --chain baobab
```

### Remove VRF Keys Specified By `id`

VRF keys can be removed based on their `id`, using the `--id` parameter applied to `vrf remove` command. The command below removes a VRF keys identified with `id=2`.

```sh
orakl-cli vrf remove \
    --id 2
```

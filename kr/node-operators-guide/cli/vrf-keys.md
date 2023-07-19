---
description: List, Generate, Insert and Remove Orakl Network VRF Keys
---

# VRF Keys

> 만약 **Orakl Network VRF Node Operator**가 아니신 경우, 이 페이지의 설명을 참고하실 필요는 없습니다.

**Orakl Network VRF Worker**는 소비자의 seed(체인에서 받은 값)를 기반으로 한 증명 가능한 무작위 숫자를 생성하기 위해 개인 VRF 키(`sk`)에 접근해야 합니다. **Orakl Network VRF Listener**는 VRF 키를 고유하게 식별하는 키 해시(`keyHash`)가 필요합니다. 일반적으로 **Orakl Network VRF Node Operator** 는 하나의 VRF 키 세트(`pk`, `sk`, `pkX`, `pkY` 및 `keyHash`) 이상을 필요로하지 않습니다.

다음은 **Orakl Network CLI** 에서 제공하는 command입니다:

- [List VRF Keys](vrf-keys.md#list-vrf-keys)
- [Generate VRF Keys](vrf-keys.md#generate-vrf-keys)
- [Insert VRF Keys](vrf-keys.md#insert-vrf-keys)
- [Remove VRF Keys Specified By `id`](vrf-keys.md#remove-vrf-keys-specified-by-id)

### List VRF Keys

Orakl Network 상태에 등록된 모든 VRF 키를 나열하려면 `vrf list` command를 사용할 수 있습니다.

```sh
orakl-cli vrf list
```

특정 체인과 연관된 VRF 키를 표시하려면 추가적으로 `--chain` 매개변수를 사용할 수 있습니다.

```sh
orakl-cli vrf list \
    --chain ${chain}
```

### Generate VRF Keys

VRF 키는 `vrf keygen` command를 사용하여 생성할 수 있습니다.

```sh
orakl-cli vrf keygen
```

`vrf keygen` command는 다음과 유사한 출력을 생성합니다. VRF 키 생성은 무작위로 이루어지므로 출력은 매번 실행할 때마다 변경됩니다. `sk` 는 신뢰할 수 없는 사람과 공유해서는 안 되는 비밀 키를 나타냅니다.&#x20;

```
sk=ebeb5229570725793797e30a426d7ef8aca79d38ff330d7d1f28485d2366de32
pk=045b8175cfb6e7d479682a50b19241671906f706bd71e30d7e80fd5ff522c41bf0588735865a5faa121c3801b0b0581440bdde24b03dc4c4541df9555d15223e82
pkX=41389205596727393921445837404963099032198113370266717620546075917307049417712
pkY=40042424443779217635966540867474786311411229770852010943594459290130507251330
keyHash=0x6f32373625e3d1f8f303196cbb78020ac2503acd1129e44b36b425781a9664ac
```

`vrf keygen` command는 VRF 키만 생성합니다. **Orakl Network VRF**에서 사용하려면 `vrf insert` command를 통해 이를 Orakl Network 상태에 삽입해야합니다.

### Insert VRF Keys

`vrf insert` command를 사용하여 새로운 VRF 키를 삽입할 수 있습니다. 아래 command는 위에서 생성한 VRF 키를 baobab 체인과 연결하는 방법을 보여줍니다.

```sh
orakl-cli vrf insert \
    --sk ebeb5229570725793797e30a426d7ef8aca79d38ff330d7d1f28485d2366de32 \
    --pk 045b8175cfb6e7d479682a50b19241671906f706bd71e30d7e80fd5ff522c41bf0588735865a5faa121c3801b0b0581440bdde24b03dc4c4541df9555d15223e82 \
    --pkX 41389205596727393921445837404963099032198113370266717620546075917307049417712 \
    --pkY 40042424443779217635966540867474786311411229770852010943594459290130507251330 \
    --keyHash 0x6f32373625e3d1f8f303196cbb78020ac2503acd1129e44b36b425781a9664ac \
    --chain baobab
```

### Remove VRF Keys Specified By `id`

VRF 키는 `--id` 매개변수를 사용하여 해당 `id`를 기반으로 제거할 수 있습니다. 이는 `vrf remove` command에 적용됩니다.

```sh
orakl-cli vrf remove \
    --id ${id}
```

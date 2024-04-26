---
description: >-
  Register organization, reporters, contracts, functions, and connect them
  together to create your white list rules
---

# Delegator

### Insert new organization

```sh
yarn cli delegator organizationInsert \
    --name ${orgName}
```

- example

```sh
yarn cli delegator organizationInsert --name bisonai
```

### List organizations

```sh
yarn cli delegator organizationList
```

### Insert new reporter

```sh
yarn cli delegator reporterInsert \
      --address ${address} \
      --organizationId ${organizationId}
```

- example

```sh
yarn cli delegator reporterInsert --address 0xab --organizationId 10
```

### List reporters

```sh
yarn cli delegator reporterList
```

### Insert new contract

```sh
yarn cli delegator contractInsert \
      --address ${address}
```

- example

```sh
yarn cli delegator contractInsert --address 0x23
```

### List contracts

```sh
yarn cli delegator contractList
```

### Insert new function

```sh
yarn cli delegator functionInsert \
      --name ${functionSignature} \
      --contractId ${contractId}
```

- example

```sh
yarn cli delegator functionInsert --name "submit(int256,uint256)" --contractId 15
```

### List functions

```sh
yarn cli delegator functionList
```

### Connect contract with reporter

```sh
yarn cli delegator contractConnect \
      --contractId 1 \
      --reporterId 1
```

### List reporters

```
yarn cli delegator reporterList
```

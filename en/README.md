---
description: >-
  Orakl Network is a decentralized oracle network that allows smart contracts to
  securely access off-chain data and other resources.
---

# Introduction

## Installation

> The oracle version `v0.1` and `v0.2` uses Solidity version `^0.8.20`. The version of npm package `@bisonai/orakl-contract` is an internal version of package to recognize changes.

```
yarn add @bisonai/orakl-contracts@v2.0.2
```

The rest of this page describes [Services](./#services) and [Payment](./#payment) options.

## Services

- [Verifiable Random Function (VRF)](developers-guide/vrf.md)
- [Request-Response](developers-guide/request-response.md)
- [Data Feed](developers-guide/data-feed.md)
- [Proof of Reserve](developers-guide/proof-of-reserve.md)

### Verifiable Randomness Function (VRF)

**Verifiable Randomness Function** allows for the generation of random numbers on the blockchain in a verifiable and transparent manner. This can be useful for a wide range of use cases, such as gaming and gambling applications, where a fair and unbiased random number generator is essential.

The detailed information about Orakl Network VRF can be found at [developer's guide on how to use VRF](developers-guide/vrf.md). If you want to start using VRF right away, we recommend to look at [an example Hardhat project using Orakl Network VRF](https://github.com/Bisonai/vrf-consumer).

### Request-Response

**Request-Response** allows to query any information off-chain and bring it to your smart contract.

The detailed information about Orakl Network Request-Response can be found at [developer's guide on how to use Request-Response](developers-guide/request-response.md). After understanding the basics of Request-Response, you can look at [an example Hardhat project using Orakl Network Request-Response](https://github.com/Bisonai/vrf-consumer).

### Data Feed

**Data Feed** provides a direct on-chain access to the latest off-chain information. The data are collected in a decentralized and secure way through a set of decentralized and reliable operators.

The detailed information about Orakl Network Data Feed can be found at [developer's guide on how to use Data Feed](developers-guide/data-feed.md). To get a hands-on experience with Orakl Network Data Feed, we recommend to explore [an example Hardhat project using Orakl Network Data Feed](https://github.com/Bisonai/data-feed-consumer).

### Proof of Reserve

**Proof of Reserve** methods function as security checks for financial institutions, particularly those involved in decentralized finance (DeFi) and blockchain systems.

The detailed information about Orakl Network Proof of Reserve can be found at [developer's guide on how to use Proof of Reserve](developers-guide/proof-of-reserve.md). To get a hands-on experience with Orakl Network Proof of Reserve, we recommend to explore [an example Hardhat project using Orakl Network Data Feed](https://github.com/Bisonai/data-feed-consumer).

## Payment & Account Types

The main payment method in Orakl Network is called a [Prepayment](developers-guide/prepayment.md). It allows users to deposit $KAIA to their Orakl Network account, and use it to request Orakl Network VRF or Orakl Network Request-Response. We provide two different account types that support the prepayment method:

- [Permanent account](./#permanent-account)
- [Temporary account](./#temporary-account)

### Permanent account

**Permanent account** allows consumers of Orakl Network to prepay for services, and then use those funds when interacting with Orakl Network. Permanent account is a separate smart contract. It is possible to define a set of consumer smart contracts that can request Orakl Network service through the account without having a direct access to its funds. Permanent account is currently a recommended way to request for both VRF and Request-Response. If you want to learn more about prepayment payment method or permanent account, go to [developer's guide on how to use Prepayment](developers-guide/prepayment.md).

### Temporary account

**Temporary account** is designed for casual Orakl Network users who want to pay for the service at the time of the request. The account exists inside of Prepayment contract since the request initiation until its fulfillment, or balance withdrawal. Temporary account can be used to request both VRF and Request-Response.

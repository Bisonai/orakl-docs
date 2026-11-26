---
description: Brief Description Of The Orakl Network For Node Operators
---

# Introduction

The Orakl Network is a service composed of [hybrid smart contracts](https://blog.chain.link/hybrid-smart-contracts-explained/) utilizing both onchain and offchain computation in order to deliver following solutions:

* [Verifiable Random Function (VRF)](../developers-guide/vrf.md)
* [Request-Response](../developers-guide/request-response.md)
* [Data Feed](../developers-guide/data-feed.md)

## Onchain Orakl Network

Onchain implementation is located under [`contracts` directory](https://github.com/Bisonai/orakl/tree/master/contracts) with all relevant smart contracts, their tests, and deployment scripts. Node operators do not have to be concerned with the content of the `contracts` directory, but they need to know about the up-to-date smart contract addresses and their latests settings in order to setup their nodes properly. In cases, where node operator needs to know more details, we are going to explain all necessary information.

## Offchain Orakl Network

Offchain part is split to several auxiliary micro services, and the main oracle solution:

* [Orakl Network API](api.md)
* [Orakl Network CLI](cli/)
* [Orakl Network Fetcher](broken-reference)
* [Orakl Network VRF](vrf.md)
* [Orakl Network Request-Response](request-response.md)
* [Orakl Network Data Feed](data-feed.md)
* [Orakl Network Delegator](delegator.md)
* [Helm Chart Infra Setup](broken-reference)

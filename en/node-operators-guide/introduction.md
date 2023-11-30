---
description: Brief Description Of The Orakl Network For Node Operators
---

# Introduction

The Orakl Network is a service composed of [hybrid smart contracts](https://blog.chain.link/hybrid-smart-contracts-explained/) utilizing both on-chain and off-chain computation in order to deliver following solutions:

* [Verifiable Random Function (VRF)](../developers-guide/vrf.md)
* [Request-Response](../developers-guide/request-response.md)
* [Data Feed](../developers-guide/data-feed.md)

## On-Chain Orakl Network

On-chain implementation is located under [`contracts` directory](https://github.com/Bisonai/orakl/tree/master/contracts) with all relevant smart contracts, their tests, and deployment scripts. Node operators do not have to be concerned with the content of the `contracts` directory, but they need to know about the up-to-date smart contract addresses and their latests settings in order to setup their nodes properly. In cases, where node operator needs to know more details, we are going to explain all necessary information.

## Off-Chain Orakl Network

Off-chain part is split to several auxiliary micro services, and the main oracle solution:

* [Orakl Network API](api.md)
* [Orakl Network CLI](cli/)
* [Orakl Network Fetcher](fetcher.md)
* [Orakl Network VRF](vrf.md)
* [Orakl Network Request-Response](request-response.md)
* [Orakl Network Data Feed](data-feed.md)
* [Orakl Network Proof of Reserve](proof-of-reserve.md)
* [Orakl Network Delegator](delegator.md)
* [Helm Chart Infra Setup](helmchart.md)

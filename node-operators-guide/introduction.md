# Introduction

Orakl Network is a service composed of [hybrid smart contracts](https://blog.chain.link/hybrid-smart-contracts-explained/) utilizing both on-chain and off-chain computation and computation in order to deliver following solutions:

* Verifiable Random Function (VRF)
* Request-Response
* Data Feed

### On-Chain Orakl Network

On-chain implementation is located under [`contracts` directory](https://github.com/Bisonai/orakl/tree/master/contracts) with all relevant smart contracts, their tests, and deployment scripts. Node operators do not have to be concerned with the content of the `contracts` directory, but they need to know about the up-to-date smart contract addresses and their latests settings in order to setup their nodes properly. In cases, where node operator needs to know more details, we are going to explain all necessary information.

### Off-Chain Orakl Network

Off-chain part is split to several auxiliary micro services, and the main oracle solution:

* Orakl Network API
* Orakl Network Fetcher
* Orakl Network Delegator
* Orakl Network
  * VRF
  * Request-Response
  * &#x20;Aggregator

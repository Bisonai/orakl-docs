---
description: Ongoing proof of reserve validation for your financial entity.
---

# Proof of Reserve

For a comprehensive illustration of utilizing **Orakl Network's Proof of Reserve**, refer to the example repository of the [`data-feed-consumer`](https://github.com/Bisonai/data-feed-consumer). The on-chain implementation for Proof of Reserve mirrors that of the Aggregator and the Aggregator Proxy.

## What is Proof of Reserve?

The **Orakl Network's Proof of Reserve (PoR)** stands as a vital element in fostering trust and transparency within the financial ecosystem of Orakl Network. 
Playing a pivotal role, Proof of Reserve is dedicated to the validation of reserve holdings for financial entities through a secure and auditable procedure. 
The GPC Proof of Reserve refers to a reserved quantity of non-fungible tokens (NFTs) issued specifically for Gold Pegged Coin.


### Supported Proof of Reserve on Cypress

<table><thead><tr><th width="157">PoR</th><th>Aggregator</th><th>AggregatorProxy</th><th>Heartbeat (m)</th></tr></thead><tbody>
    <tr>
        <td>GPC (Gold Pegged Coin)</td>
        <td><a href="https://www.klaytnfinder.io/account/0xb5e91e5CE0B8e6fc3029b4E9ce057675a2c96dd1">0xb5e91e5CE0B8e6fc3029b4E9ce057675a2c96dd1</a></td>
        <td><a href="https://www.klaytnfinder.io/account/0x9FbA23B10692cB3fa6Fea09834855ACc597BD180">0x9FbA23B10692cB3fa6Fea09834855ACc597BD180</a></td>
        <td>60</td></tr></tr></tbody></table>

### Supported Proof of Reserve on Baobab

<table><thead><tr><th width="157">PoR</th><th>Aggregator</th><th>AggregatorProxy</th><th>Heartbeat (m)</th></tr></thead><tbody>
    <tr>
        <td>GPC (Gold Pegged Coin)</td><td><a href="https://baobab.klaytnfinder.io/account/0x58798D6Ca40480DF2FAd1b69939C3D29d91b60d3">0x58798D6Ca40480DF2FAd1b69939C3D29d91b60d3</a></td>
        <td><a href="https://baobab.klaytnfinder.io/account/0x821179a6d4F62fa6979BF42bEb9eE16a1F14C4eD">0x821179a6d4F62fa6979BF42bEb9eE16a1F14C4eD</a></td>
        <td>60</td></tr></tr></tbody></table>

</tbody></table>

## How to read from Aggregator contract of PoR

The Proof of Reserve (PoR) in Orakl Network is realized through two key smart contracts: `Aggregator` and `AggregatorProxy`. These contracts form a pair, representing a specific data feed, and enable continuous access to the reserve holdings. The `Aggregator` receives regular updates from off-chain oracles, ensuring accurate and up-to-date reserve information. The `AggregatorProxy` serves as a consistent API for accessing the submitted data.

For a detailed understanding of PoR and its integration, refer to the [Orakl Network Data Feed](./data-feed.md) documentation. This documentation provides comprehensive insights into the architecture, reading procedures, and the relationship between Aggregator and AggregatorProxy, enhancing your grasp of PoR functionality.

[`How to read data from aggregator contract`](./data-feed#initialization)


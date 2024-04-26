# Orakl Network Proof of Reserve

## Description

The **Orakl Network Proof of Reserve** is a critical component within the Orakl Network ecosystem, designed to establish and verify the reserve holdings of financial entities. This service ensures transparency and trust in the financial operations by providing a secure and auditable process for validating reserve data. The Orakl Network Proof of Reserve is a cornerstone within the ecosystem, dedicated to establishing trust in financial operations. This service seamlessly integrates off-chain and on-chain processes, providing a robust framework to verify and authenticate reserve holdings.

A Proof of Reserve is defined by a pair of an adapter and an aggregator, and can be accessed on-chain through a `AggregatorProxy` smart contract, where the on-chain implementation of contracts are reused from [Orakl Network Data Feed](./data-feed.md). The `AggregatorProxy` is an auxiliary contract that redirects read requests to `Aggregator` contract. The Proof of Reserve's `Aggregator` contract holds all submission values that is served to consumers through `AggregatorProxy` contract.

Every proof of reserve has configuration that describes the least frequent update interval called `heartbeat`, and minimum deviation threshold (`deviationTreshold`).

The **Orakl Network Proof of Reserve** operates as a streamlined, single-process system, easily triggered by a Cron job. The initial phase involves retrieving the most recent `roundId` and `PoR value` from the Proof of Reserve `Aggregator contract`. Subsequently, the process assesses eligibility for submission through a combination of the `Heartbeat Check` and `Deviation Check`. If either condition is met, the final step involves fetching data from the `API resource` and reporting the next round to the `POR contract`. This cohesive workflow ensures efficient and timely execution of the `Proof of Reserve` process.

The code is located under [`core` directory](https://github.com/Bisonai/orakl/tree/master/core/src/por).

## Configuration

Before we launch the **Orakl Network Proof of Reserve**, we must specify [several environment variables](https://github.com/Bisonai/orakl/blob/master/node/.env.example). The environment variables are automatically loaded from a `.env` file.

```.env
# POR
POR_REPORTER_PK=
POR_CHAIN=
POR_PROVIDER_URL=
# (optional) defaults to 3000
POR_PORT=
```

- `POR_REPORTER_PK`: designated por reporter's pk, should be whitelisted from the aggregator contract
- `POR_CHAIN`: chain name of POR (`baobab` or `cypress`)
- `POR_PROVIDER_URL`: json rpc url to be used for reading and submitting onchain
- `POR_PORT`: port to be used for healthcheck (defaults to `3000`)

## Launch

Setup environment variable for orakl node before lunch, readme files can be found [here](https://github.com/Bisonai/orakl/blob/master/node/README.md)

from ./node path run following command

```sh
task local:por
```

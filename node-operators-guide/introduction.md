---
description: Brief Description Of The Orakl Network For Node Operators
---

# Introduction

The Orakl Network is a service composed of [hybrid smart contracts](https://blog.chain.link/hybrid-smart-contracts-explained/) utilizing both on-chain and off-chain computation in order to deliver following solutions:

* [Verifiable Random Function (VRF)](../developers-guide/verifiable-random-function-vrf.md)
* [Request-Response](../developers-guide/request-response.md)
* [Data Feed](../developers-guide/data-feed.md)

## On-Chain Orakl Network

On-chain implementation is located under [`contracts` directory](https://github.com/Bisonai/orakl/tree/master/contracts) with all relevant smart contracts, their tests, and deployment scripts. Node operators do not have to be concerned with the content of the `contracts` directory, but they need to know about the up-to-date smart contract addresses and their latests settings in order to setup their nodes properly. In cases, where node operator needs to know more details, we are going to explain all necessary information.

## Off-Chain Orakl Network

Off-chain part is split to several auxiliary micro services, and the main oracle solution:

* [Orakl Network API](introduction.md#orakl-network-api)
* [Orakl Network CLI](introduction.md#orakl-network-cli)
* [Orakl Network Fetcher](introduction.md#orakl-network-fetcher)
* [Orakl Network Delegator](introduction.md#orakl-network-delegator)
* [Orakl Network VRF](introduction.md#orakl-network-vrf)
* [Orakl Network Request-Response](introduction.md#orakl-network-request-response)
* [Orakl Network Aggregator](introduction.md#orakl-network-aggregator)

### Orakl Network API

The **Orakl Network API** is an abstraction layer representing a single source of truth for Orakl Network deployment. The code is located under [`api` directory](https://github.com/Bisonai/orakl/tree/master/api).&#x20;

The **Orakl Network API** has to be reachable from every Orakl Network service, and accessible to the [**Orakl Network CLI**](introduction.md#orakl-network-cli). It is implemented as a REST web server that accept requests from other services, and the state of the Orakl Network is stored in PostgreSQL database. The **Orakl Network API** has to be launched and configured before any other microservice.

#### Configuration

Before we launch the **Orakl Network API**, we must specify [few environment variables](https://github.com/Bisonai/orakl/blob/master/api/.env.example). The environment variables are automatically loaded from a `.env` file.

* `DATABASE_URL`
* `APP_PORT`

`DATABASE_URL` represents a [connection string](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING) to a database that will hold the Orakl Network state.

> The format of `DATABASE_URL` should be `postgresql://[userspec@][hostspec][/dbname][?paramspec]`. An example string can look as follows `postgresql://bisonai@localhost:5432/orakl?schema=public.`&#x20;

`APP_PORT` represents a port on which the **Orakl Network API** will be running. This port will be necessary when we connect to **Orakl Network API** from other services.

#### Launch

To launch the **Orakl Network API** from source code in the production, one must first build the service, and then it can be launched.

```sh
yarn build
yarn start:prod
```

#### Architecture

<figure><img src="../.gitbook/assets/orakl-network-api.png" alt=""><figcaption><p>Orakl Network API</p></figcaption></figure>

### Orakl Network CLI

The Orakl Network CLI is a tool to configure and manage Orakl Network. The Orakl Network allows us to read and modify the state of Orakl Network, therefore it is very important tool for node operator. The code is located under [`cli` directory](../developers-guide/data-feed.md).

To learn more about the **Orakl Network CLI**, start with the [Introduction page of Orakl Network CLI section](broken-reference).

### Orakl Network Fetcher

The Orakl Network Fetcher is an auxiliary service for Data Feed solution to collect the most up-to-date data from various sources.&#x20;

The code is located under `fetcher` directory.

#### Configuration

Before we launch the **Orakl Network Fetcher**, we must specify [several environment variables](https://github.com/Bisonai/orakl/blob/master/fetcher/.env.example). The environment variables are automatically loaded from a `.env` file.

* `REDIS_HOST`
* `REDIS_PORT`
* `ORAKL_NETWORK_API_URL`
* `APP_PORT`

`REDIS_HOST` and `REDIS_PORT` represent host and port of [Redis](https://redis.io/) to which the **Orakl Network Fetcher** connect to. The default values are `localhost` and `6379`, respectively. Redis is used indirectly through [BullMQ](https://docs.bullmq.io/) to collect data in regular predefined intervals.&#x20;

`ORAKL_NETWORK_API_URL` corresponds to url where the **Orakl Network API** is running. Collected and aggregated data by the **Orakl Network Fetcher** will be send to [PostgreSQL](https://www.postgresql.org/) through the **Orakl Network API** interface.

`APP_PORT` represents a port on which the **Orakl Network Fetcher** will be running. This port will be necessary when we connect to **Orakl Network API** from other services (e.g. **Orakl Network CLI**).

#### Adapter & Aggregator

The **Orakl Network Fetcher** and the [**Orakl Network Aggregator**](introduction.md#orakl-network-aggregator) are configured with **adapter** and **aggregator** abstractions. Every data feed collected by the **Orakl Network Fetcher** and then submitted to on-chain by the **Orakl Network Aggregator** is defined with an adapter-aggregator pair. Adapters and aggregators are defined in JSON format. You can find a detailed description of them below.

An **adapter** is a set of data sources (`feeds`) and post-processing rules (`reducers`) that are applied on data received from `feeds`. Additionally, every adapter has a `name`, `decimals` and an `adapterHash`. `decimals` property represents a number of decimal points in which the post processed values are  encoded. The values itself are in an `integer` format and decimal points are stored separately. Lastly, `adapterHash` is computed from all properties of adapter except the `adapterHash` itself. It was defined for safety reasons so nobody can accidentally modify the adapter without anybody noticing.

```json
{
  "adapterHash": "0xe63985ed9d9aae887bdcfa03b53a1bea6fd1acc58b8cd51a9a69ede43eac6235",
  "name": "BTC-USD",
  "decimals": 8,
  "feeds": [
    {
      "name": "Binance-BTC-USD",
      "definition": {
        "url": "https://api.binance.us/api/v3/ticker/price?symbol=BTCUSD",
        "headers": {
          "Content-Type": "application/json"
        },
        "method": "GET",
        "reducers": [
          {
            "function": "PARSE",
            "args": [
              "price"
            ]
          },
          {
            "function": "POW10",
            "args": 8
          },
          {
            "function": "ROUND"
          }
        ]
      }
    }
  ]
}
```

An **aggregator** is described with on-chain metadata (`address`), off-chain metadata (`name`, `heartbeat`, `threshold`, `absoluteThreshold`), and connection to an adapter (`adapterHash`). `address` corresponds to deployed smart contract `Aggregator` that accepts submissions from whitelisted node operators for a data feed defined using an adapter that is identified with `adapterHash`. `name` offers a description of the aggregator. `heartbeat` defines the lowest frequency update (value is denoted in milliseconds) of `Aggregator` smart contract. `threshold` represents a minimum required value deviation (e.g. 0.05 equals to ±5 % deviation) in the data feed that leads to early submission to data feed. When the range of possible values in data feed is between 0 and ∞, `absoluteThreshold` is used to define a minimum absolute change that must be observed before the data feed starts being updated again after the data feed value became a zero. `adapterHash` represents a unary relationship between aggregator and adapter.

```json
{
  "aggregatorHash": "0xfda8c08a8b7641e001ad23c0fb363a9e7aab1e3a7eb8a6ddee41deeb7e3ef279",
  "name": "BTC-USD",
  "address": "0x15c0b3ea93ed4de0a1f93f4ae130aefd8f2e8ccb",
  "heartbeat": 15000,
  "threshold": 0.05,
  "absoluteThreshold": 0.1,
  "adapterHash": "0xe63985ed9d9aae887bdcfa03b53a1bea6fd1acc58b8cd51a9a69ede43eac6235"
}
```

#### Launch

To launch the **Orakl Network Fetcher** from source code in the production, one must first build the service, and then it can be launched.

```sh
yarn build
yarn start:prod
```

After the **Orakl Network Fetcher** is launched, all active aggregators will start to

* collect data for each data source defined in adapter feeds of activated aggregator, and
* compute and store their aggregate.

The collected and computed data are sent through the **Orakl Network API** to PostgreSQL.

#### Add adapter & aggregator

If there are no adapters and aggregators in Orakl Network state, you can create them through the **Orakl Network CLI**. To find out, if there are any adapter and aggregator in Orakl Network state, you can execute the command below.

```
orakl-cli adapter list
orakl-cli aggregator list
```

Agregators are associated with `chain`, therefore if you have not defined any chain through the **Orakl Network API** yet, you need to do it before adding any aggregator.

```sh
orakl-cli chain insert --name localhost
```

An example of adding adapter and aggregator to `localhost` chain is shown at the code listing below. Please note that `adapterHash` in adapter and aggregator JSON files has to be same, otherwise they would not be associated. If you try to add aggregator with `adapterHash` that has not been registered, the operation will be aborted.

```sh
orakl-cli adapter insert \
    --file-path [path/to/adapter.json]

orakl-cli aggregator insert \
    --file-path [path/to/aggregator.json] \
    --chain localhost
```

#### Activate aggregator

After the adapters and aggregators are registered to Orakl Network state, they are in an inactive state at first. If we want them to use for data collection, we have to activate them. Activation can be performed through the **Orakl Network CLI**.

```sh
orakl-cli fetcher start \
    --id ${aggregatorhash} \
    --chain ${chainName}
```

#### Deactivate aggregator

Data collection defined with an adapter-aggregator pair can be stopped anytime by executing a command below with appropriate `aggregatorHash`.

```sh
orakl-cli fetcher start \
    --id ${aggregatorHash} \
    --chain ${chainName}
```

#### Architecture

<figure><img src="../.gitbook/assets/orakl-network-fetcher.png" alt=""><figcaption><p>Orakl Network Fetcher</p></figcaption></figure>

### Orakl Network Delegator

### Orakl Network VRF

The **Orakl Network VRF** is one of the main Orakl Network solutions. It provides an access to provably random number generator.

The code is located under [`core` directory](https://github.com/Bisonai/orakl/tree/master/core), and separated to three independent microservices: listener, worker and reporter.

#### Configuration

Before we launch the **Orakl Network VRF**, we must specify [several environment variables](https://github.com/Bisonai/orakl/blob/master/core/.env.example). The environment variables are automatically loaded from a `.env` file.

* `NODE_ENV=production`
* `ORAKL_NETWORK_API_URL`
* `CHAIN`
* `HEALTH_CHECK_PORT`
* `SLACK_WEBHOOK_URL`
* `LOG_LEVEL`
* `LOG_DIR`
* `REDIS_HOST`
* `REDIS_PORT`
* `HOST_SETTINGS_LOG_DIR`

The **Orakl Network VRF** is implemented in Node.js which uses `NODE_ENV` environment variable to signal the execution environment (e.g. `production`, `development`). [Setting the environment to `production`](https://nodejs.dev/en/learn/nodejs-the-difference-between-development-and-production/) generally ensures that logging is kept to a minimum, and more caching levels take place to optimize performance.

`ORAKL_NETWORK_API_URL` corresponds to url where the **Orakl Network API** is running. Collected and aggregated data by the **Orakl Network Fetcher** will be send to [PostgreSQL](https://www.postgresql.org/) through the **Orakl Network API** interface.

`CHAIN` environment variable specifies on which chain the **Orakl Network VRF** will be running, and which resources will be collected from the **Orakl Network API**.

The **Orakl Network VRF** does not offer a rich REST API, but defines a health check endpoint (`/`) \
served under a port denoted as `HEALTH_CHECK_PORT`.

Errors and warnings emitted by the **Orakl Network VRF** can be [sent to Slack channels through a slack webhook](https://api.slack.com/messaging/webhooks). The webhook URL can be set with the `SLACK_WEBOOK_URL` environment variable.

Setting a level of logs emitted by a running instance is set through `LOG_LEVEL` environment variable, and can be one of the following: `error`, `warning`, `info`, `debug` and `trace`, ordered from the most restrictive to the least. By selecting any of the available options you subscribe to the specified level and all levels with lower restrictiveness.

Logs are sent to console, and to file which is located at `LOG_DIR` directory.

`REDIS_HOST` and `REDIS_PORT` represent host and port of [Redis](https://redis.io/) to which the **Orakl Network Fetcher** connect to. The default values are `localhost` and `6379`, respectively. Redis is used indirectly through [BullMQ](https://docs.bullmq.io/) to collect data in regular predefined intervals.&#x20;

#### Orakl Network VRF Worker

To be able to run VRF as a node operator, one must have registered VRF keys in [`VRFCoordinator`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/VRFCoordinator.sol), and VRF keys has to be in Orakl Network state as well. VRF worker will load them from the **Orakl Network API** when it is launched.

If you do not have VRF keys, you can generate them with the **Orakl Network CLI** using the following command.

```sh
orakl-cli vrf keygen
```

The output of generated command will be similar to the one below, but including the keys on the right side of the keys (`sk`, `pk`, `pkX`,`pkY`, and `keyHash`). VRF keys are generated randomly, therefore every time you call the `keygen` command, you receive a different output. `sk` represents a secret key which is used to generate the VRF `beta` and `pi`. This secret key should never be shared with anybody except the required personnel.

```
sk=
pk=
pkX=
pkY=
keyHash=
```

To store VRF keys in Orakl Network state use `orakl-cli vrf insert` command. Parameter `--chain` corresponds to the network name to which VRF keys will be associated.

```sh
orakl-cli vrf insert \
    --chain ${chain} \
    --pk ${pk} \
    --sk ${sk} \
    --pkX ${pkX} \
    --pkY ${pkY} \
    --keyHash ${keyHash}
```

#### Orakl Network VRF Listener

The **Orakl Network API** holds information about all listeners. The command below adds a single VRF listener to the Orakl Network state to listen on `vrfCoordinatorAddress` for `RandomWordsRequested` event. The `chain` parameter specifies a chain on which we expect to operate with the **Orakl Network VRF Listener**.

```sh
orakl-cli listener insert \
    --service VRF \
    --chain ${chain} \
    --address ${vrfCoordinatorAddress} \
    --eventName RandomWordsRequested
```

#### Launch

Before launching the VRF solution, the **Orakl Network API** has to be accessible from the **Orakl Network VRF** to load VRF keys, and listener settings.

After the **Orakl Network API** is healthy, VRF microservices (listener, worker, reporter) can be launched in an arbitrary order. Microservices communicate with each other through the BullMQ - job queue.

```sh
yarn start:listener:vrf
yarn start:worker:vrf
yarn start:reporter:vrf
```

#### Architecture

<figure><img src="../.gitbook/assets/orakl-network-vrf.png" alt=""><figcaption><p>Orakl Network VRF</p></figcaption></figure>

### Orakl Network Request-Response

The **Orakl Network Request-Response** is one of the main Orakl Network solutions. It provides an access to off-chain data from on-chain smart contracts. Requests are emitted through on-chain event, captured by the **Orakl Network Request-Response Listener**, processed by the **Orakl Network Request-Response Worker** and eventually responded back to on-chain through the **Orakl Network Request-Response Reporter**.

The code is located under [`core` directory](https://github.com/Bisonai/orakl/tree/master/core), and separated to three independent microservices: listener, worker and reporter.

#### Configuration

Before we launch the **Orakl Network VRF**, we must specify [several environment variables](https://github.com/Bisonai/orakl/blob/master/core/.env.example). The environment variables are automatically loaded from a `.env` file.

* `NODE_ENV=production`&#x20;
* `ORAKL_NETWORK_API_URL`
* `CHAIN`&#x20;
* `HEALTH_CHECK_PORT`
* `SLACK_WEBHOOK_URL`
* `LOG_LEVEL`
* `LOG_DIR`
* `REDIS_HOST`
* `REDIS_PORT`
* `HOST_SETTINGS_LOG_DIR`

#### Orakl Network Request-Response Listener

The **Orakl Network API** holds information about all listeners. The command below adds a single Request-Response listener to the Orakl Network state to listen on `requestResponseCoordinatorAddress` for `DataRequested` event. The `chain` parameter specifies a chain on which we expect to operate with the **Orakl Network Request-Response Listener**.

```sh
orakl-cli listener insert \
    --service RequestResponse \
    --chain ${chain} \
    --address ${requestResponseCoordinatorAddress} \
    --eventName DataRequested
```

#### Launch

Before launching the Request-Response solution, the **Orakl Network API** has to be accessible from the **Orakl Network Request-Response** to load listener settings.

After the **Orakl Network API** is healthy, Request-Response microservices (listener, worker, reporter) can be launched in an arbitrary order. Microservices communicate with each other through the BullMQ - job queue.

```sh
yarn start:listener:request_response
yarn start:worker:request_response
yarn start:reporter:request_response
```

#### Architecture

The architecture is very similar to the **Orakl Network VRF**. The only difference is that the **Orakl Network Request-Response Worker** fetches and processes data based on the on-chain request.

<figure><img src="../.gitbook/assets/orakl-network-request-response.png" alt=""><figcaption><p>Orakl Network Request-Response</p></figcaption></figure>

### Orakl Network Data Feed

The **Orakl Network Data Feed** is one of the main Orakl Network solutions. The goal of the **Orakl Network Data Feed** is to provide frequent data updates from off-chain to on-chain. The data feed is created from a submission pool that is composed of most up-to-date values reported by verified node operators.

A single data feed is defined by a pair of an adapter and an aggregator, and can be accessed on-chain through a `AggregatorProxy` smart contract. The `AggregatorProxy` is an auxiliary contract that redirects read requests to `Aggregator` contract. The `Aggregator` contract holds all submissions from all node operators, and aggregated value that is served to consumers through `AggregatorProxy` contract.

Every data feed has configuration that describes the least frequent update interval called `heartbeat`, minimum deviation threshold (`deviationTreshold`), and minimum absolute threshold (`absoluteThreshold`). Data feed is updated in rounds which can be started by any of **Orakl Network Data Feed** node operators. Once the round is started, every node operator has to submit their latest observed value for the specific data feed. The first submitted transaction that opens a new round emits a `NewRound` event which is captured by the node operators running the **Orakl Network Data Feed Listener** microservice. The `NewRound` event includes a `roundId` value representing the ID of the newly started round. It is possible that **Orakl Network Data Feed Worker** is already processing the round of the same ID. If that is the case, listener will drop the request, otherwise it will be pass it to worker. The requests coming to the **Orakl Network Data Feed Worker** can include information about the round ID but does not have to.

* If the worker request includes the `roundId`, worker only asks the **Orakl Network API** for the latest data feed value aggregated from all observed data sources.
* If the worker request does not include the `roundId` (e.g. coming either due to `heartbeat` , `deviationThreshold` or `absoluteTreshold`), then the worker first asks `Aggregator` which round is currently open, and additionally it fetches the latest data feed value aggregate through the **Orakl Network API** .

After the worker knows which `roundId` it can report on, and after it has access to the latest value aggregate of data feed, it passes the job to the **Orakl Network Data Feed Reporter**. The reporter creates a transaction that contains the data accepted from worker, and reports it to the `Aggregator` contract. Lastly, the reporter creates a time delayed job to automatically start a next round in `heartbeat` milliseconds. If there exists any idle delayed job from previous submissions for the same data feed, it is replaced with the latest one.

The `deviationThreshold` and `absoluteTreshold` trigger events for a new data feed round are executed from the **Orakl Network Fetcher**.

The code is located under [`core` directory](https://github.com/Bisonai/orakl/tree/master/core), and separated to three independent microservices: listener, worker and reporter.

#### Orakl Network Data Feed Listener

The **Orakl Network API** holds information about all listeners. The command below adds a single Aggregator listener to the Orakl Network state to listen on `aggregatorAddress` for `NewRound` event. The `chain` parameter specifies a chain on which we expect to operate with the **Orakl Network Data Feed Listener**.

```sh
orakl-cli listener insert \
    --service Aggregator \
    --chain ${chain} \
    --address ${aggregatorAddress} \
    --eventName NewRound
```

#### Orakl Network Data Feed Adapter & Aggregator

```sh
orakl-cli adapter insert \
    --file-path ${adapterJsonFile}

orakl-cli aggregator insert \
    --chain ${chain} \
    --file-path ${aggregatorJsonFile}
```

#### Configuration

Before we launch the **Orakl Network Data Feed**, we must specify [several environment variables](https://github.com/Bisonai/orakl/blob/master/core/.env.example). The environment variables are automatically loaded from a `.env` file.

* `NODE_ENV=production`
* `ORAKL_NETWORK_API_URL`
* `CHAIN`
* `HEALTH_CHECK_PORT`
* `SLACK_WEBHOOK_URL`
* `LOG_LEVEL`
* `LOG_DIR`
* `REDIS_HOST`&#x20;
* `REDIS_PORT`
* `HOST_SETTINGS_LOG_DIR`

#### Launch

Before launching the Data Feed solution, the **Orakl Network API** has to be accessible from the **Orakl Network Data Feed** to load listener and adapter-aggregator settings.

After the **Orakl Network API** is healthy, Data Feed microservices (listener, worker, reporter) can be launched in an arbitrary order. Microservices communicate with each other through the BullMQ - job queue.

```sh
yarn start:listener:aggregator
yarn start:worker:aggregator
yarn start:reporter:aggregator
```

#### Architecture

<figure><img src="../.gitbook/assets/orakl-network-data-feed.png" alt=""><figcaption><p>Orakl Network Data Feed</p></figcaption></figure>


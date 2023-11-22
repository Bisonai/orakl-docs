# Orakl Network Data Feed

## Description

The **Orakl Network Data Feed** is one of the main Orakl Network solutions. The goal of the **Orakl Network Data Feed** is to provide frequent data updates from off-chain to on-chain. The data feed is created from a submission pool that is composed of most up-to-date values reported by verified node operators.

A single data feed is defined by a pair of an adapter and an aggregator, and can be accessed on-chain through a `AggregatorProxy` smart contract. The `AggregatorProxy` is an auxiliary contract that redirects read requests to `Aggregator` contract. The `Aggregator` contract holds all submissions from all node operators, and aggregated value that is served to consumers through `AggregatorProxy` contract.

Every data feed has configuration that describes the least frequent update interval called `heartbeat`, minimum deviation threshold (`deviationTreshold`), and minimum absolute threshold (`absoluteThreshold`). Data feed is updated in rounds which can be started by any of **Orakl Network Data Feed** node operators. Once the round is started, every node operator has to submit their latest observed value for the specific data feed. The first submitted transaction that opens a new round emits a `NewRound` event which is captured by the node operators running the **Orakl Network Data Feed Listener** microservice. The `NewRound` event includes a `roundId` value representing the ID of the newly started round. It is possible that **Orakl Network Data Feed Worker** is already processing the round of the same ID. If that is the case, listener will drop the request, otherwise it will be pass it to worker. The requests coming to the **Orakl Network Data Feed Worker** can include information about the round ID but does not have to.

* If the worker request includes the `roundId`, worker only asks the **Orakl Network API** for the latest data feed value aggregated from all observed data sources.
* If the worker request does not include the `roundId` (e.g. coming either due to `heartbeat` , `deviationThreshold` or `absoluteTreshold`), then the worker first asks `Aggregator` which round is currently open, and additionally it fetches the latest data feed value aggregate through the **Orakl Network API** .

After the worker knows which `roundId` it can report on, and after it has access to the latest value aggregate of data feed, it passes the job to the **Orakl Network Data Feed Reporter**. The reporter creates a transaction that contains the data accepted from worker, and reports it to the `Aggregator` contract. Lastly, the reporter creates a time delayed job to automatically start a next round in `heartbeat` milliseconds. If there exists any idle delayed job from previous submissions for the same data feed, it is replaced with the latest one.

The `deviationThreshold` and `absoluteTreshold` trigger events for a new data feed round are executed from the **Orakl Network Fetcher**.

The code is located under [`core` directory](https://github.com/Bisonai/orakl/tree/master/core), and separated to three independent microservices: listener, worker and reporter.

## State Setup

The **Orakl Network Data Feed** requires an access to state of listeners, adapters and aggregators.

### Listener

The **Orakl Network API** holds information about all listeners. The command below adds a single Aggregator listener to the Orakl Network state to listen on `aggregatorAddress` for `NewRound` event. The `chain` parameter specifies a chain on which we expect to operate with the **Orakl Network Data Feed Listener**.

```sh
orakl-cli listener insert \
    --service Aggregator \
    --chain ${chain} \
    --address ${aggregatorAddress} \
    --eventName NewRound
```

### Reporter

The **Orakl Network API** holds information about all reporters. The command below adds a single Data Feed reporter to the Orakl Network state to report to `oracleAddress`. The chain parameter specifies a chain on which we expect to operate. Reporter is defined by an `address` and a `privateKey` parameters.

```sh
orakl-cli reporter insert \
  --service DATA_FEED \
  --chain ${chain} \
  --address  ${address} \
  --privateKey ${privateKey} \
  --oracleAddress ${oracleAddress}
```

### Adapter & Aggregator

```sh
orakl-cli adapter insert \
    --file-path ${adapterJsonFile}

orakl-cli aggregator insert \
    --chain ${chain} \
    --file-path ${aggregatorJsonFile}
```

### Proxies (Optional)

The Orakl Network offers an optional proxy feature that allows data fetching through proxy resources. The following command adds a single proxy to the Orakl Network state. The chain parameter specifies the blockchain network on which the operation is expected to occur. It is essential to provide values for all three parameters: `host`, `port`, and `protocol`.


```sh
orakl-cli proxy insert \
    --protocol ${protocol} \
    --host ${host} \
    --port ${port}
```

## Configuration

Before we launch the **Orakl Network Data Feed**, we must specify [several environment variables](https://github.com/Bisonai/orakl/blob/master/core/.env.example). The environment variables are automatically loaded from a `.env` file.

* `NODE_ENV=production`
* `CHAIN`
* `PROVIDER_URL`
* `ORAKL_NETWORK_API_URL`
* `LOG_LEVEL`
* `REDIS_HOST`
* `REDIS_PORT`
* `HEALTH_CHECK_PORT`
* `SLACK_WEBHOOK_URL`

The **Orakl Network Data Feed** is implemented in Node.js which uses `NODE_ENV` environment variable to signal the execution environment (e.g. `production`, `development`). [Setting the environment to `production`](https://nodejs.org/en/learn/getting-started/nodejs-the-difference-between-development-and-production) generally ensures that logging is kept to a minimum, and more caching levels take place to optimize performance.

`CHAIN` environment variable specifies on which chain the **Orakl Network Data Feed** will be running, and which resources will be collected from the **Orakl Network API**.

`PROVIDER_URL` defines an URL string representing a JSON-RPC endpoint that listener, worker, and reporter communicate through.

`ORAKL_NETWORK_API_URL` corresponds to url where the **Orakl Network API** is running. The **Orakl Network API** interface is used to access Orakl Network state such as listener, worker, and reporter configuration.

Setting a level of logs emitted by a running instance is set through `LOG_LEVEL` environment variable, and can be one of the following: `error`, `warning`, `info`, `debug` and `trace`, ordered from the most restrictive to the least. By selecting any of the available options you subscribe to the specified level and all levels with lower restrictiveness.

`REDIS_HOST` and `REDIS_PORT` represent host and port of [Redis](https://redis.io/) to which all **Orakl Network Data Feed** microservices connect. The default values are `localhost` and `6379`, respectively.&#x20;

The **Orakl Network Data Feed** does not offer a rich REST API, but defines a health check endpoint (`/`) served under a port denoted as `HEALTH_CHECK_PORT`.

Errors and warnings emitted by the **Orakl Network Data Feed** can be [sent to Slack channels through a slack webhook](https://api.slack.com/messaging/webhooks). The webhook URL can be set with the `SLACK_WEBOOK_URL` environment variable.

## Launch

Before launching the Data Feed solution, the **Orakl Network API** has to be accessible from the **Orakl Network Data Feed** to load listener and adapter-aggregator settings.

After the **Orakl Network API** is healthy, Data Feed microservices (listener, worker, reporter) can be launched in an arbitrary order. Microservices communicate with each other through the BullMQ - job queue.

```sh
yarn start:listener:data_feed
yarn start:worker:data_feed
yarn start:reporter:data_feed
```

## Architecture

<figure><img src="../.gitbook/assets/orakl-network-data-feed.png" alt=""><figcaption><p>Orakl Network Data Feed</p></figcaption></figure>

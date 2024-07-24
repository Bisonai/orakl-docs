# Orakl Network Request-Response

## Description

The **Orakl Network Request-Response** is one of the main Orakl Network solutions. It provides an access to off-chain data from on-chain smart contracts. Requests are emitted through on-chain event, captured by the **Orakl Network Request-Response Listener**, processed by the **Orakl Network Request-Response Worker** and eventually responded back to on-chain through the **Orakl Network Request-Response Reporter**.

The code is located under [`core` directory](https://github.com/Bisonai/orakl/tree/master/core), and separated to three independent microservices: listener, worker and reporter.

## State Setup

The **Orakl Network Request-Response** requires an access to state for listeners and reporters.

### Listener

The **Orakl Network API** holds information about all listeners. The command below adds a single Request-Response listener to the Orakl Network state to listen on `requestResponseCoordinatorAddress` for `DataRequested` event. The `chain` parameter specifies a chain on which we expect to operate with the **Orakl Network Request-Response Listener**.

```sh
orakl-cli listener insert \
    --service REQUEST_RESPONSE \
    --chain ${chain} \
    --address ${requestResponseCoordinatorAddress} \
    --eventName DataRequested
```

* example

```sh
orakl-cli listener insert \
    --service REQUEST_RESPONSE \
    --chain baobab \
    --address 0x12 \
    --eventName DataRequested
```

### Reporter

The **Orakl Network API** holds information about all reporters. The command below adds a single Request-Response reporter to the Orakl Network state to report to `oracleAddress`. The chain parameter specifies a chain on which we expect to operate. Reporter is defined by an `address` and a `privateKey` parameters.

```sh
orakl-cli reporter insert \
  --service REQUEST_RESPONSE \
  --chain ${chain} \
  --address  ${address} \
  --privateKey ${privateKey} \
  --oracleAddress ${oracleAddress}
```

* example

```sh
orakl-cli reporter insert \
  --service REQUEST_RESPONSE \
  --chain baobab \
  --address  0xab \
  --privateKey abc \
  --oracleAddress ${oracleAddress}
```

## Configuration

Before we launch the **Orakl Network Request-Response**, we must specify [several environment variables](https://github.com/Bisonai/orakl/blob/master/core/.env.example). The environment variables are automatically loaded from a `.env` file.

* `NODE_ENV=production`
* `CHAIN`
* `PROVIDER_URL`
* `ORAKL_NETWORK_API_URL`
* `LOG_LEVEL`
* `REDIS_HOST`
* `REDIS_PORT`
* `HEALTH_CHECK_PORT`
* `SLACK_WEBHOOK_URL`

The **Orakl Network Request-Response** is implemented in Node.js which uses `NODE_ENV` environment variable to signal the execution environment (e.g. `production`, `development`). [Setting the environment to `production`](https://nodejs.org/en/learn/getting-started/nodejs-the-difference-between-development-and-production) generally ensures that logging is kept to a minimum, and more caching levels take place to optimize performance.

`CHAIN` environment variable specifies on which chain the **Orakl Network Request-Response** will be running, and which resources will be collected from the **Orakl Network API**.

`PROVIDER_URL` defines an URL string representing a JSON-RPC endpoint that listener and reporter communicate through.

`ORAKL_NETWORK_API_URL` corresponds to url where the **Orakl Network API** is running. The **Orakl Network API** interface is used to access Orakl Network state such as listener configuration.

Setting a level of logs emitted by a running instance is set through `LOG_LEVEL` environment variable, and can be one of the following: `error`, `warning`, `info`, `debug` and `trace`, ordered from the most restrictive to the least. By selecting any of the available options you subscribe to the specified level and all levels with lower restrictiveness.

`REDIS_HOST` and `REDIS_PORT` represent host and port of [Redis](https://redis.io/) to which all **Orakl Network Request-Response** microservices connect. The default values are `localhost` and `6379`, respectively.

The **Orakl Network Request-Response** does not offer a rich REST API, but defines a health check endpoint (`/`) served under a port denoted as `HEALTH_CHECK_PORT`.

Errors and warnings emitted by the **Orakl Network Request-Response** can be [sent to Slack channels through a slack webhook](https://api.slack.com/messaging/webhooks). The webhook URL can be set with the `SLACK_WEBOOK_URL` environment variable.

## Launch

Before launching the Request-Response solution, the **Orakl Network API** has to be accessible from the **Orakl Network Request-Response** to load listener settings.

After the **Orakl Network API** is healthy, launch the Request-Response service, which consists of listener, worker, and reporter microservices, with the command below. Microservices communicate with each other through the BullMQ - job queue.

```sh
yarn start:core:request_response
```

Run in dev mode through the following command:

```sh
yarn dev:core:request_response
```

It's also possible to run the microservices separately in any arbitrary order:

```sh
yarn start:listener:request_response
yarn start:worker:request_response
yarn start:reporter:request_response
```

## Quick launch with Docker

From [orakl](https://github.com/Bisonai/orakl) repository's root, run the following command to build all images:

```bash
docker-compose -f docker-compose.local-core.yaml build
```

Set wallet credentials, `ADDRESS` and `PRIVATE_KEY` values, in the [.core-cli-contracts.env](https://github.com/Bisonai/orakl/blob/master/dockerfiles/local-vrf-rr/envs/.core-cli-contracts.env) file. Keep in mind that the default chain is `localhost`. If changes are required, update `CHAIN` (other options being `baobab` and `cypress`) and `PROVIDER_URL` values. Note that if the chain is not `localhost`, `Coordinator` and `Prepayment` contracts won't be deployed. Instead, Bisonai's already deployed [contract addresses](https://github.com/Bisonai/request-response-consumer/blob/376de8136c6ae22ac7c8769bb8e72085146d018f/hardhat.config.ts#L44C5-L54C6) will be used. After setting the appropriate `.env` values, run the following command to start the Request-Response service:

```bash
SERVICE=rr docker-compose -f docker-compose.local-core.yaml up --force-recreate
```

**Note** that the current docker implementation is designed to run a single service, either `rr` or `vrf`, at a time. Therefore, it's highly recommended to add `--force-recreate` when running `docker-compose up` command. That will restart all containers thus removing all the modified data in those containers.

Here is what happens after the above command is run:

* `api`, `postgres`, `redis`, and `json-rpc` services will start as separate docker containers
* `postgres` will get populated with necessary data:
  * chains
  * services
  * listener (after contracts are deployed)
  * reporter (after contracts are deployed)
* migration files in `contracts/v0.1/migration/` get updated with provided keys and other values
* if the chain is `localhost`:
  * `contracts/v0.1/hardhat.config.cjs` file gets updated with `PROVIDER_URL`
  * relevant coordinator and prepayment contracts get deployed

## Architecture

The architecture is very similar to the **Orakl Network VRF**. The only difference is that the **Orakl Network Request-Response Worker** fetches and processes data based on the on-chain request.

<figure><img src="../.gitbook/assets/orakl-network-request-response (1).png" alt=""><figcaption><p>Orakl Network Request-Response</p></figcaption></figure>

# Orakl Network VRF

## Description

The **Orakl Network VRF** is one of the main Orakl Network solutions. It provides an access to provably random number generator.

The code is located under [`core` directory](https://github.com/Bisonai/orakl/tree/master/core), and separated to three independent microservices: listener, worker and reporter.

## State Setup

The **Orakl Network VRF** requires an access to state of listeners and VRF keys.

### Listener

The **Orakl Network API** holds information about all listeners. The command below adds a single VRF listener to the Orakl Network state to listen on `vrfCoordinatorAddress` for `RandomWordsRequested` event. The `chain` parameter specifies a chain on which we expect to operate with the **Orakl Network VRF Listener**.

```sh
orakl-cli listener insert \
    --service VRF \
    --chain ${chain} \
    --address ${vrfCoordinatorAddress} \
    --eventName RandomWordsRequested
```

* example

```sh
orakl-cli listener insert --service VRF --chain baobab --address 0xDA8c0A00A372503aa6EC80f9b29Cc97C454bE499 --enventName RandomWordsRequested
```

### Reporter

The **Orakl Network API** holds information about all reporters. The command below adds a single VRF reporter to the Orakl Network state to report to `oracleAddress`. The chain parameter specifies a chain on which we expect to operate. Reporter is defined by an `address` and a `privateKey` parameters.

```sh
orakl-cli reporter insert \
  --service VRF \
  --chain ${chain} \
  --address  ${address} \
  --privateKey ${privateKey} \
  --oracleAddress ${oracleAddress}
```

* example

```sh
orakl-cli reporter insert \
  --service VRF \
  --chain baobab \
  --address  0x12 \
  --privateKey abc \
  --oracleAddress 0xDA
```

### VRF Keys

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

## Configuration

Before we launch the **Orakl Network VRF**, we must specify [several environment variables](https://github.com/Bisonai/orakl/blob/master/core/.env.example). The environment variables are automatically loaded from a `.env` file.

* `NODE_ENV=production`
* `CHAIN`
* `PROVIDER_URL`
* `ORAKL_NETWORK_API_URL`
* `LOG_LEVEL`
* `REDIS_HOST`
* `REDIS_PORT`
* `HEALTH_CHECK_PORT`
* `SLACK_WEBHOOK_URL`

The **Orakl Network VRF** is implemented in Node.js which uses `NODE_ENV` environment variable to signal the execution environment (e.g. `production`, `development`). [Setting the environment to `production`](https://nodejs.org/en/learn/getting-started/nodejs-the-difference-between-development-and-production) generally ensures that logging is kept to a minimum, and more caching levels take place to optimize performance.

`CHAIN` environment variable specifies on which chain the **Orakl Network VRF** will be running, and which resources will be collected from the **Orakl Network API**.

`PROVIDER_URL` defines an URL string representing a JSON-RPC endpoint that listener and reporter communicate through.

`ORAKL_NETWORK_API_URL` corresponds to url where the **Orakl Network API** is running. The **Orakl Network API** interface is used to access Orakl Network state such as listener and VRF key configuration.

Setting a level of logs emitted by a running instance is set through `LOG_LEVEL` environment variable, and can be one of the following: `error`, `warning`, `info`, `debug` and `trace`, ordered from the most restrictive to the least. By selecting any of the available options you subscribe to the specified level and all levels with lower restrictiveness.

`REDIS_HOST` and `REDIS_PORT` represent host and port of [Redis](https://redis.io/) to which all **Orakl Network VRF** microservices connect. The default values are `localhost` and `6379`, respectively.

The **Orakl Network VRF** does not offer a rich REST API, but defines a health check endpoint (`/`) served under a port denoted as `HEALTH_CHECK_PORT`.

Errors and warnings emitted by the **Orakl Network VRF** can be [sent to Slack channels through a slack webhook](https://api.slack.com/messaging/webhooks). The webhook URL can be set with the `SLACK_WEBOOK_URL` environment variable.

## Launch

Before launching the VRF solution, the **Orakl Network API** has to be accessible from the **Orakl Network VRF** to load VRF keys, and listener settings.

After the **Orakl Network API** is healthy, launch the VRF service, which consists of listener, worker, and reporter microservices, with the command below. Microservices communicate with each other through the BullMQ - job queue.

```sh
yarn start:core:vrf
```

Run in dev mode through the following command:

```sh
yarn dev:core:vrf
```

It's also possible to run the microservices separately in any arbitrary order:

```sh
yarn start:listener:vrf
yarn start:worker:vrf
yarn start:reporter:vrf
```

## Quick launch with Docker

From [orakl](https://github.com/Bisonai/orakl) repository's root, run the following command to build all images:

```bash
docker-compose -f docker-compose.local-core.yaml build
```

Set wallet credentials, `ADDRESS` and `PRIVATE_KEY` values, in the [.core-cli-contracts.env](https://github.com/Bisonai/orakl/blob/master/dockerfiles/local-vrf-rr/envs/.core-cli-contracts.env) file. Keep in mind that the default chain is `localhost`. If changes are required, update `CHAIN` (other options being `baobab` and `cypress`) and `PROVIDER_URL` values. Note that if the chain is not `localhost`, `Coordinator` and `Prepayment` contracts won't be deployed. Instead, Bisonai's already deployed [contract addresses](https://github.com/Bisonai/vrf-consumer/blob/9b06ddd10b472d821878c9994463856664387c85/hardhat.config.ts#L60-L68) will be used. After setting the appropriate `.env` values, run the following command to start the VRF service:

```bash
SERVICE=vrf docker-compose -f docker-compose.local-core.yaml up --force-recreate
```

**Note** that the current docker implementation is designed to run a single service, either `rr` or `vrf`, at a time. Therefore, it's highly recommended to add `--force-recreate` when running `docker-compose up` command. That will restart all containers thus removing all the modified data in those containers.

Here is what happens after the above command is run:

* `api`, `postgres`, `redis`, and `json-rpc` services will start as separate docker containers
* `postgres` will get populated with necessary data:
  * chains
  * services
  * vrf keys
  * listener (after contracts are deployed)
  * reporter (after contracts are deployed)
* migration files in `contracts/v0.1/migration/` get updated with provided keys and other values
* if the chain is `localhost`:
  * `contracts/v0.1/hardhat.config.cjs` file gets updated with `PROVIDER_URL`
  * relevant coordinator and prepayment contracts get deployed

## Architecture

<figure><img src="../.gitbook/assets/orakl-network-vrf (1).png" alt=""><figcaption><p>Orakl Network VRF</p></figcaption></figure>

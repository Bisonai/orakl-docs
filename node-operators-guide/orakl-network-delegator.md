# Orakl Network Delegator

## Description

The **Orakl Network Delegator** is an settings of the who can use Delegated transaction payment in Orakl Network. The code is located under [`delegator` directory](https://github.com/Bisonai/orakl/tree/master/delegator).&#x20;

## Sign Transaction

The main feature of **Orakl Network Delegator** is to accept transaction requests from the reporters and `sign` the transaction as a fee payer after validations are checked. It is implemented as a REST web server and all the transactions are stored in the PostgreSQL database.

### Sign

To Sign the transaction you can use `api/v1/sign` endpoint.

```shell
curl -X 'POST' \
  'http://localhost:3000/api/v1/sign' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "from": "string",
  "to": "string",
  "input": "string",
  "gas": "string",
  "value": "string",
  "chainId": "string",
  "gasPrice": "string",
  "nonce": "string",
  "v": "string",
  "r": "string",
  "s": "string",
  "rawTx": "string",
  "signedRawTx": "string"
}'
```

## Setup Whitelist Settings

### Contract

First step is to add `contract address` of the service to the whitelist where the reporters can use delegated transactions to call specified contract address.

For adding new contract, you can use `api/v1/contract` endpoint.

```shell
curl -X 'POST' \
  'http://localhost:3000/api/v1/contract' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "address": "string"
}'
```

### Function

After adding the contract address, the next step is to define which function call methods are included to `whitelist` for a specific contract address.

To add new function name, you can use `api/v1/function` endpoint.

```shell
curl -X 'POST' \
  'http://localhost:3000/api/v1/function' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "increment()",
  "contractId": 1,
  "encodedName": ""
}'
```

### Organization

Before add reporter, first we need to add Organization name, if it is not already defined.

To add new `Organization name`, you can use `api/v1/organization` api endpoint.

```shell
curl -X 'POST' \
  'http://localhost:3000/api/v1/organization' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "BISONAI"
}'
```

### Reporter

The final step of setting up is to add `reporter address` to the whitelist, specifying that the current reporter is connected to which organization and the contract address it will be connected.

To add new reporter address, you can use `api/v1/reporter` api endpoint.

```shell
curl -X 'POST' \
  'http://localhost:3000/api/reporter' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "address": "string",
  "contractId": 0,
  "organizationId": 0
}'
```

## Configuration

Before we launch the **Orakl Network Delegator**, we must specify [few environment variables](https://github.com/Bisonai/orakl/blob/master/delegator/.env.example). The environment variables are automatically loaded from a `.env` file.

- `DATABASE_URL`
- `PROVIDER_URL`
- `APP_PORT`
- `DELEGATOR_FEEPAYER_PK`
- `DELEGATOR_REPORTER_PK`

`DATABASE_URL` represents a [connection string](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING) to a database that will hold the Orakl Network state.

> The format of `DATABASE_URL` should be `postgresql://[userspec@][hostspec][/dbname][?paramspec]`. An example string can look as follows `postgresql://bisonai@localhost:5432/orakl?schema=public.`&#x20;

`PROVIDER_URL` defines an URL string representing a JSON-RPC endpoint that listener, worker, and reporter communicate through.

`APP_PORT` represents a port on which the **Orakl Network Delegator** will be running. This port will be necessary when we connect to **Orakl Network Delegator** from other services.

`DELEGATOR_FEEPAYER_PK` is the PK of delegator account which is used to sign all the transaction as a fee payer.

`DELEGATOR_REPORTER_PK` is the PK of reporter account where is used for make transaction as a Reporter. `DELEGATOR_REPORTER_PK` is used only for test scenario.

## Launch

To launch the **Orakl Network Delegator** from source code in the production, one must first build the service, and then it can be launched.

```sh
yarn build
yarn start:prod
```

## Architecture

<figure><img src="../.gitbook/assets/orakl-network-delegator.png" alt=""><figcaption><p>Orakl Network Delegator</p></figcaption></figure>

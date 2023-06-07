# Installing Orakl Network with Helm Charts

## Description

This section describes how to install Orakl Network Services through the Helm Chart. 
This document uses helm chart to deploy in cloud (AWS, GCP) environment. 

+ Kubernetes
+ Postgresql
+ Redis
+ Persistent Volumes

## Installation

### Register the Orakl Network helm chart repository
```bash
helm repo add orakl https://helm.orakl.network
helm repo update
```

### 01. Create namespace for kubernetes
```bash
  kubectl create namespace orakl
  kubectl create namespace redis
```
### 02. Storage
AWS Installation
+ You must first create an efs file storage in AWS and have an ID.
```bash
helm install storage -n orakl orakl/orakl-log-aws-storage \ 
    --set "config.efsFileSystemId=${your efs file system id}" \ 
    --set "config.region=${your aws resion}" \ 
    --set "config.size=100Gi" 
```
GCP Installation
+ In GCP, you must first create a file storage and have a name for the storage
```bash
helm install storage -n orakl orakl/orakl-log-gcp-storage \ 
    --set "config.size=100Gi" \ 
    --set "config.pdName=${your gcp storage name}" 
```

### 03. Api
Before installing the API, you must have a postgresql database ready.
```bash
helm install api -n orakl orakl/orakl-api \ 
    --set "global.config.DATABASE_URL=${your database url}" \ 
    --set "global.config.ENCRYPT_PASSWORD=${your key password}" \ 
    --set "global.config.APP_PORT=3030"
```

+ `DATABASE_URL` : postgresql://{user_id}:{user_password}@{host_name}:{port}/{database_name}

+ Typically, we'll create a database called `orakl` and proceed from there

+ make sure for security reason not to use admin account. create new user for the databse.

+ `ENCRYPT_PASSWORD` : You can set the key to any key you want as the conversion key. When the reporter's private key is stored in the database, it is encrypted and stored with this key.
  

### 04. Fetcher
To install Orakl Fetcher, you need to have Redis set up beforehand. 
```bash
helm install fetcher -n orakl orakl/orakl-fetcher \ 
    --set "global.config.APP_PORT=4040" \ 
    --set "global.config.REDIS_HOST=${your redis host addressd }" \ 
    --set "global.config.REDIS_PORT=${your redis port | 6379}" \ 
    --set "global.config.ORAKL_NETWORK_API_URL=http://orakl-api.orakl.svc.cluster.local:3030/api/v1" 
```

+ `ORAKL_NETWORK_API_URL`: This is the address to communicate with the Pod you installed in step 03. It uses the usual Kubernetes domain for communication, which is `http://{api pod's service name}.{namespace}.svc.cluster.local:3030/api/v1` So if you installed in a namespace other than the orakl namespace, the address of the API server will need to be changed, for example, if the namespace is default, it will be `http://orakl-api.default.svc.cluster.local:3030/api/v1`

+ `REDIS_HOST`, `REDIS_PORT`: You can use a fresh deployment of Redis in Kubernetes, or you can use your own Redis if you have one

Enable Fetcher with [aggregatorHash](https://config.orakl.network/#aggregator-baobab)
```bash 
  yarn cli fetcher start --id ${aggregatorHash} --chain ${chainName}
```


### 05. Delegator
```bash
helm install delegator -n orakl orakl/orakl-delegator  \
      --set "global.config.DATABASE_URL=${your database url}" \
      --set "global.config.APP_PORT=5050" \ 
      --set "global.config.PROVIDER_URL=${your Json Rpc node address}"\
      --set "global.config.DELEGATOR_FEEPAYER_PK=${your delegator account private key}"
```

+ `DATABASE_URL` : postgresql://{user_id}:{user_password}@{host_name}:{port}/{database_name}

+ The database you create here should be a new database, different from the one you created in step 01. This database will be named `orakl_delegator`

+ `PROVIDER_URL` : The JSON RPC address of the node to use ex) https://api.baobab.klaytn.net:8651

+ `DELEGATOR_FEEPAYER_PK` : If you don't have a balance in the account you need to report to, you'll need to pay through a payee account. You'll need to enter the `private key` of the payoff account.


### 06. Cli
```bash
helm install cli -n orakl orakl/orakl-cli \
    --set "global.config.ORAKL_NETWORK_API_URL=http://orakl-api.orakl.svc.cluster.local:3030/api/v1" \
    --set "global.config.ORAKL_NETWORK_FETCHER_URL=http://orakl-fetcher.orakl.svc.cluster.local:4040/api/v1" \
    --set "global.config.ORAKL_NETWORK_DELEGATOR_URL=http://orakl-delegator.orakl.svc.cluster.local:5050/api/v1" 
```

+ `ORAKL_NETWORK_API_URL`, `ORAKL_NETWORK_FETCHER_URL`, `ORAKL_NETWORK_DELEGATOR_URL` : These 3 URLs are the same convention we used to deploy the fetcher earlier, just make sure to include the service name and namespace.

### 07. Basic Configuration
+ list all pods in orakl namespace
  ```bash 
    kubectl get pods -n orakl 
  ```
+ access to cli pod
  ```bash
    kubectl exec -it cli-7b8df47f-bdlzv -n orakl -- /bin/bash 
  ```

### You can set the default settings through the [orakl cli part](https://docs.orakl.network/docs/node-operators-guide/cli). Here we'll show you an example.

+ network setting
  ```bash
    yarn cli chain insert --name baobab
  ```

+ network list a
  ```bash
    yarn cli chain list
  ```

+ The result should be
  ```bash
    root@cli-7b8df47f-bdlzv:/app# yarn cli chain list

    yarn run v1.22.19
      $ node --no-warnings --experimental-specifier-resolution=node --experimental-json-modules dist/index.js chain list
    [ { id: '1', name: 'baobab' } ]
    Done in 0.70s.
  ```

+ setting service 
  ```bash
    yarn cli service insert --name DATA_FEED
  ```

+ service check
  ```bash
    yarn cli service list
  ```

+ the result should be
  ```bash
    root@cli-7b8df47f-bdlzv:/app# yarn cli service list

    yarn run v1.22.19
    $ node --no-warnings --experimental-specifier-resolution=node --experimental-json-modules dist/index.js service list
    [ { id: '1', name: 'DATA_FEED' } ]
    Done in 0.66s.
  ```

+ setting listener

  To set up a listener, you need to know the contract address of the listener associated with the DATA FEED. In this article, we will focus on `BNB-USDT`. This contract is already deployed on Bisonai and the contract address can be found in the [Address section of the Aggregator Baobab](https://config.orakl.network/#aggregator-baobab) in the Orakl Config documentation. 
  ```bash
    yarn cli listener insert \
    --chain baobab \
    --service DATA_FEED \
    --address 0x731A5AFB6e021579138Ea469B25C2ab46ff44199 \
    --eventName NewRound
  ```

+ setting aggregator

  ```bash
    yarn cli aggregator insert \
    --source https://config.orakl.network/adapter/bnb-usdt.adapter.json \
    --chain baobab
    ```

  source address can be found [Orakl Config](https://config.orakl.network/)


+ setting reporter
  ```bash
  yarn cli reporter insert \ 
  --chain baobab \
  --service DATA_FEED \
  --address ${your reporter account address} \
  --privateKey ${your reporter account password }
  --oracleAddress 0x731A5AFB6e021579138Ea469B25C2ab46ff44199
  ```
  oracleAddress refer `BNB-USDT` contract address


+ setting delegator
  ```bash
   yarn cli delegator organizationInsert --name ${your organazation name}
  ```  

  ```bash
   yarn cli delegator reporterInsert \
      --address ${your reporter account address of BNB-USDT} \
      --organizationId 1
  ```    
  The reporter address should be match with your BNB-USDT reporter's account address.
  The reporter's account address must be `lowercase`. Even if the reporter's account address is already mixed with capitalization, please make it lowercase here. We'll fix this in the future (issue caused by switching from ethers.js to caver.js)

  ```bash
   yarn cli delegator contractInsert \
        --address "0x731A5AFB6e021579138Ea469B25C2ab46ff44199"
  ```
  The contract address is `BNB-USDT`'s contract

  ```bash
    yarn cli delegator functionInsert \
      --name "submit(uint256,int256)" \
      --contractId 1
  ```
  contractId should match with contract id which deployed. If you want to check contract ID inserted in database `yarn cli delegator contractList`. You can find out `id` from list.

  ```bash 
    yarn cli delegator contractConnect \
      --contractId 1 \
      --reporterId 1
  ```
  This is the task that connects the contract and the reporter together. This can be used in the future if the contract and reporter are different or change. Reporter's id can be found `yarn cli delegator reporterList`

### 08. Datafeed (aggregator)

```bash
  helm install aggregator -n orakl orakl/orakl-aggregator \
    --set "global.config.CHAIN=${your network name}" \
    --set "global.config.LOG_DIR=/app/log" \    
    --set "global.config.LOG_LEVEL=info" \        
    --set "global.config.HEALTH_CHECK_PORT=8080" \
    --set "global.config.NODE_ENV=production" \            
    --set "global.config.ORAKL_NETWORK_API_URL=http://orakl-api.orakl.svc.cluster.local:3030/api/v1" \                
    --set "global.config.ORAKL_NETWORK_DELEGATOR_URL=http://orakl-delegator.orakl.svc.cluster.local:5050/api/v1" \                    
    --set "global.config.PROVIDER_URL=${your network provider url}" \
    --set "global.config.REDIS_HOST=${your redis host}" \
    --set "global.config.REDIS_PORT=${your redis port}" \
    --set "global.config.SLACK_WEBHOOK_URL=${your slack hook url}"
```
  + `CHAIN`: baobab | cypress
  + `ORAKL_NETWORK_API_URL`, `ORAKL_NETWORK_DELEGATOR_URL` : These 2 URLs are the same convention we used to deploy the fetcher earlier, just make sure to include the service name and namespace.
  + `PROVIDER_URL` : The JSON RPC address of the node to use ex) https://api.baobab.klaytn.net:8651
  + `SLACK_WEBHOOK_URL₩ : If there is no value, you can leave it blank.
  + `REDIS_HOST`, `REDIS_PORT`: You can use a fresh deployment of Redis in Kubernetes, or you can use your own Redis if you have one
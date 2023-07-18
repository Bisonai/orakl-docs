# Helm Chart Infra Setup

## Description

이 섹션에서는 Helm 차트를 통해 Orakl Network Services를 설치하는 방법에 대해 설명합니다. 이 문서는 클라우드(AWS, GCP) 환경에서 배포하기 위해 Helm 차트를 사용합니다.

- Kubernetes
- Postgresql (V.14)
- Redis (latest)
- Persistent Volumes

## Installation

### 01. Orakl Network 헬름 차트 저장소를 등록합니다.

```bash
helm repo add orakl https://helm.orakl.network
helm repo update
```

### 02. Kubernetes를 위한 네임스페이스를 생성합니다

```bash
  kubectl create namespace orakl
  kubectl create namespace redis
```

### 03. 스토리지

AWS 설치

- 먼저 AWS에서 EFS 파일 스토리지를 생성하고 해당 ID를 가져와야 합니다.

```bash
helm install storage -n orakl orakl/orakl-log-aws-storage \
    --set "config.efsFileSystemId=${your efs file system id}" \
    --set "config.region=${your aws resion}" \
    --set "config.size=100Gi"
```

GCP 설치

- GCP에서는 먼저 파일 스토리지를 생성하고 스토리지에 이름을 지정해야 합니다.

```bash
helm install storage -n orakl orakl/orakl-log-gcp-storage \
    --set "config.size=100Gi" \
    --set "config.pdName=${your gcp storage name}"
```

### 04. Api

API를 설치하기 전에 준비된 PostgreSQL 데이터베이스가 있어야 합니다.

```bash
helm install api -n orakl orakl/orakl-api \
    --set "global.config.DATABASE_URL=${your database url}" \
    --set "global.config.ENCRYPT_PASSWORD=${your key password}" \
    --set "global.config.APP_PORT=3030"
```

- `DATABASE_URL` : postgresql://{user_id}:{user_password}@{host_name}:{port}/{database_name}
- 일반적으로 orakl이라는 이름의 데이터베이스를 생성하고 그로부터 진행합니다.
- 보안상의 이유로 관리자 계정을 사용하지 않도록 주의하고, 데이터베이스를 위해 새로운 사용자를 생성하십시오.
- `ENCRYPT_PASSWORD` : 변환 키로 사용할 원하는 키를 설정할 수 있습니다. 리포터의 개인 키가 데이터베이스에 저장될 때, 이 키로 암호화되어 저장됩니다.

### 05. Fetcher

Orakl Fetcher를 설치하려면 미리 Redis를 설정해야합니다.

```bash
helm install fetcher -n orakl orakl/orakl-fetcher \
    --set "global.config.APP_PORT=4040" \
    --set "global.config.REDIS_HOST=${your redis host address }" \
    --set "global.config.REDIS_PORT=${your redis port | 6379}" \
    --set "global.config.ORAKL_NETWORK_API_URL=http://orakl-api.orakl.svc.cluster.local:3030/api/v1"
```

- `ORAKL_NETWORK_API_URL`: 이는 03 단계에서 설치한 Pod과 통신하기 위한 주소입니다. 통신을 위해 일반적으로 Kubernetes 도메인을 사용하며, 예를 들어 `http://{api pod의 서비스 이름}.{namespace}.svc.cluster.local:3030/api/v1` 과 같습니다. 따라서 orakl 네임스페이스 이외의 다른 네임스페이스에 설치한 경우 API 서버의 주소를 변경해야 합니다. 예를 들어, 네임스페이스가 default인 경우 `http://orakl-api.default.svc.cluster.local:3030/api/v1`과 같습니다.
- `REDIS_HOST`, `REDIS_PORT`: Kubernetes에서 새로운 Redis 배포를 사용하거나 기존의 Redis를 사용할 수 있습니다.

### 06. Cli

```bash
helm install cli -n orakl orakl/orakl-cli \
    --set "global.config.ORAKL_NETWORK_API_URL=http://orakl-api.orakl.svc.cluster.local:3030/api/v1" \
    --set "global.config.ORAKL_NETWORK_FETCHER_URL=http://orakl-fetcher.orakl.svc.cluster.local:4040/api/v1" \
    --set "global.config.ORAKL_NETWORK_DELEGATOR_URL=http://orakl-delegator.orakl.svc.cluster.local:5050/api/v1"
```

- `ORAKL_NETWORK_API_URL`, `ORAKL_NETWORK_FETCHER_URL` : 이 두 개의 URL은 이전에 fetcher를 배포할 때 사용한 규칙과 동일합니다. 서비스 이름과 네임스페이스를 포함하는지 확인해주세요.
- `ORAKL_NETWORK_DELEGATOR_URL` : 이 URL은 곧 사용 가능할 예정입니다. Delegator에 관련된 부분은 현재 이관 작업이 진행 중입니다.

### 07. 기본 구성

Aggregator Baobab에서 https://config.orakl.network/ 을 확인해보면 12개의 컨트랙트가 있고 각 컨트랙트에는 주소가 있습니다. 이후에는 더 많은 컨트랙트가 추가될 예정입니다. 리포터 계정을 활성화하려면 이 컨트랙트에 화이트리스트에 등록해야 할 12개의 계정이 필요합니다. 계정을 활성화하려면 business@orakl.network로 연락주시기 바랍니다.

- list all pods in orakl namespace
  ```bash
    kubectl get pods -n orakl
  ```
- access to cli pod

  ```bash
    kubectl exec -it cli-7b8df47f-bdlzv -n orakl -- /bin/bash
  ```

  [orakl cli part](https://docs.orakl.network/docs/node-operators-guide/cli)를 통해 기본 설정을 할 수 있습니다. 여기에는 예시를 보여드리겠습니다.

* network setting

  ```bash
    yarn cli chain insert --name baobab
  ```

* network list a

  ```bash
    yarn cli chain list
  ```

* The result should be

  ```bash
    root@cli-7b8df47f-bdlzv:/app# yarn cli chain list

    yarn run v1.22.19
      $ node --no-warnings --experimental-specifier-resolution=node --experimental-json-modules dist/index.js chain list
    [ { id: '1', name: 'baobab' } ]
    Done in 0.70s.
  ```

* setting service

  ```bash
    yarn cli service insert --name DATA_FEED
  ```

* service check

  ```bash
    yarn cli service list
  ```

* the result should be

  ```bash
    root@cli-7b8df47f-bdlzv:/app# yarn cli service list

    yarn run v1.22.19
    $ node --no-warnings --experimental-specifier-resolution=node --experimental-json-modules dist/index.js service list
    [ { id: '1', name: 'DATA_FEED' } ]
    Done in 0.66s.
  ```

* setting listener

  리스너를 설정하려면 데이터 피드와 관련된 리스너의 컨트랙트 주소를 알아야 합니다. 이 문서에서는 BNB-USDT에 초점을 맞출 것입니다. 이 컨트랙트는 이미 Bisonai에 배포되었으며, Orakl Config 문서의 [Aggregator Baobab의 주소 섹션](https://config.orakl.network/#aggregator-baobab)에서 컨트랙트 주소를 찾을 수 있습니다.

  ```bash
    yarn cli listener insert \
      --chain baobab \
      --service DATA_FEED \
      --address 0x731a5afb6e021579138ea469b25c2ab46ff44199 \
      --eventName NewRound
  ```

* setting adapter

  ```bash
    yarn cli adapter insert \
  	  --source https://config.orakl.network/adapter/bnb-usdt.adapter.json
        --chain baobab
  ```

  소스 주소는 [Orakl Config](https://config.orakl.network/)에서 찾을 수 있습니다.

* setting aggregator

  ```bash
    yarn cli aggregator insert \
      --source https://config.orakl.network/aggregator/baobab/bnb-usdt.aggregator.json \
      --chain baobab
  ```

  소스 주소는 [Orakl Config](https://config.orakl.network/)에서 찾을 수 있습니다.

* setting reporter

  ```bash
  yarn cli reporter insert \
    --chain baobab \
    --service DATA_FEED \
    --address ${your reporter account address} \
    --privateKey ${Your reporter account private key}
    --oracleAddress 0x731a5afb6e021579138ea469b25c2ab46ff44199
  ```

  oracleAddress는 `BNB-USDT` 계약 주소를 참조합니다.

* setting delegator

  ```bash
   yarn cli delegator organizationInsert --name ${your organazation name}
  ```

  ```bash
   yarn cli delegator reporterInsert \
      --address ${your reporter account address of BNB-USDT} \
      --organizationId 1
  ```

  리포터 주소는 BNB-USDT 리포터의 계정 주소와 일치해야 합니다. 리포터의 계정 주소는 모두 `소문자`여야 합니다. 이미 대소문자가 섞인 리포터의 계정 주소라도 여기에서는 소문자로 입력해주세요. 이는 나중에 수정할 예정입니다 (ethers.js에서 caver.js로 전환하면서 발생한 문제).

  ---

  ```bash
   yarn cli delegator contractInsert \
        --address "0x731a5afb6e021579138ea469b25c2ab46ff44199"
  ```

  해당 계약의 주소는 `BNB-USDT`의 계약입니다.

  ---

  ```bash
    yarn cli delegator functionInsert \
      --name "submit(uint256,int256)" \
      --contractId 1
  ```

  contractId는 배포된 계약의 계약 ID와 일치해야 합니다. 데이터베이스에 삽입된 계약 ID를 확인하려면 `yarn cli delegator contractList`를 사용하십시오. 목록에서 `id` 를 찾을 수 있습니다.

---

```bash
  yarn cli delegator contractConnect \
    --contractId 1 \
    --reporterId 1
```

이 작업은 계약과 리포터를 연결하는 작업입니다. 계약과 리포터가 다른 경우나 변경된 경우에도 이를 활용할 수 있습니다. 리포터의 ID는 `yarn cli delegator reporterList`에서 찾을 수 있습니다.

---

[aggregatorHash](https://config.orakl.network/#aggregator-baobab)를 사용하여 Fetcher를 활성화하세요.

```bash
  yarn cli fetcher start --id ${aggregatorHash} --chain ${chainName}
```

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

- `CHAIN`: baobab | cypress
- `ORAKL_NETWORK_API_URL`, `ORAKL_NETWORK_DELEGATOR_URL` : 이 두 개의 URL은 이전에 fetcher를 배포할 때 사용한 규칙과 동일합니다. 서비스 이름과 네임스페이스를 포함하는지 확인하세요.
- `PROVIDER_URL` : 사용할 노드의 JSON RPC 주소입니다. 예) `https://api.baobab.klaytn.net:8651`
- `SLACK_WEBHOOK_URL` : 값이 없는 경우 비워둘 수 있습니다.
- `REDIS_HOST`, `REDIS_PORT`: Kubernetes에서 새로운 Redis를 배포하거나, 이미 보유하고 있는 Redis를 사용할 수 있습니다.

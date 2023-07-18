# Orakl Network VRF

## Description

**Orakl Network VRF** 는 Orakl Network의 주요 솔루션 중 하나입니다. 이는 검증 가능한 난수 생성기에 대한 접근을 제공합니다.

해당 코드는 [`core` 디렉토리](https://github.com/Bisonai/orakl/tree/master/core)에 위치하며, listener, worker, reporter 세 개의 독립적인 마이크로서비스로 분리되어 있습니다.

## State Setup

**Orakl Network VRF** 는 listener와 VRF 키의 상태에 대한 액세스를 필요로 합니다.

### Listener

**Orakl Network API**는 모든 listener에 대한 정보를 보유하고 있습니다. 아래 command는 하나의 VRF listener를 Orakl Network 상태에 추가하여 `vrfCoordinatorAddress` 에서 `RandomWordsRequested` 이벤트를 수신하도록 합니다. `chain` 매개변수는 **Orakl Network VRF Listener**를 사용할 체인을 지정합니다.

```sh
orakl-cli listener insert \
    --service VRF \
    --chain ${chain} \
    --address ${vrfCoordinatorAddress} \
    --eventName RandomWordsRequested
```

### Reporter

**Orakl Network API** 는 모든 리포터에 대한 정보를 보유하고 있습니다. 아래 command는 Orakl Network 상태에 단일 VRF 리포터를 추가하여 `oracleAddress`에 보고합니다. Chain 매개변수는 운영을 기대하는 체인을 지정합니다. 리포터는 `address` 와 `privateKey` 매개변수로 정의됩니다.

```sh
orakl-cli reporter insert \
  --service VRF \
  --chain ${chain} \
  --address  ${address} \
  --privateKey ${privateKey} \
  --oracleAddress ${oracleAddress}
```

### VRF Keys

VRF를 노드 운영자로 실행하려면 [`VRFCoordinator`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/VRFCoordinator.sol)에 등록된 VRF 키가 있어야하며, VRF 키도 Orakl Network 상태에 있어야합니다. VRF worker는 시작될 때 **Orakl Network API** 에서 이를 로드합니다.

VRF 키가 없는 경우, 다음 command를 사용하여 **Orakl Network CLI** 를 통해 키를 생성할 수 있습니다.

```sh
orakl-cli vrf keygen
```

생성된 command의 출력은 다음과 유사하며, 오른쪽 키 (`sk`, `pk`, `pkX`,`pkY`, 및 `keyHash`)들이 포함됩니다. VRF 키는 무작위로 생성되므로 `keygen` command를 호출할 때마다 다른 출력을 받게됩니다. `sk` 는 VRF `beta` 및 `pi`를 생성하는 데 사용되는 비밀 키를 나타냅니다. 이 비밀 키는 관련 인원 이외에는 아무에게도 공유되어서는 안됩니다.

```
sk=
pk=
pkX=
pkY=
keyHash=
```

VRF 키를 Orakl Network 상태에 저장하려면 `orakl-cli vrf insert` command를 사용하세요. `--chain` 매개변수는 VRF 키가 연결될 네트워크 이름을 나타냅니다.

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

**Orakl Network VRF** 를 시작하기 전에 [여러 환경 변수](https://github.com/Bisonai/orakl/blob/master/core/.env.example)를 지정해야 합니다. 환경 변수는 `.env` 파일에서 자동으로 로드됩니다.

- `NODE_ENV=production`
- `CHAIN`
- `PROVIDER_URL`
- `ORAKL_NETWORK_API_URL`
- `LOG_LEVEL`
- `LOG_DIR`
- `REDIS_HOST`
- `REDIS_PORT`
- `HEALTH_CHECK_PORT`
- `HOST_SETTINGS_LOG_DIR`
- `SLACK_WEBHOOK_URL`

**Orakl Network VRF** 는 Node.js로 구현되어 있으며, 실행 환경을 나타내는 `NODE_ENV` 환경 변수를 사용합니다 (예: `production`, `development`). [환경을 `production` 으로 설정](https://nodejs.dev/en/learn/nodejs-the-difference-between-development-and-production/)하면 일반적으로 로깅이 최소화되고 성능을 최적화하기 위해 더 많은 캐싱 수준이 적용됩니다.

`CHAIN` 환경 변수는 **Orakl Network VRF** 가 실행될 체인을 지정하며, **Orakl Network API** 에서 수집할 리소스를 결정합니다.

`PROVIDER_URL` 은 listener와 reporter가 통신하는 JSON-RPC 엔드포인트를 나타내는 URL 문자열을 정의합니다.

`ORAKL_NETWORK_API_URL` 은 **Orakl Network API** 가 실행 중인 URL을 나타냅니다. **Orakl Network API** 인터페이스는 listener 및 VRF 키 구성과 같은 Orakl Network 상태에 액세스하는 데 사용됩니다.

실행 중인 인스턴스에서 발생하는 로그의 수준은 `LOG_LEVEL` 환경 변수를 통해 설정되며 다음 중 하나일 수 있습니다: `error`, `warning`, `info`, `debug`, `trace` 입니다. 이용 가능한 옵션 중 하나를 선택하면 해당 수준과 더 낮은 제한 수준의 모든 로그를 구독하게 됩니다.

로그들은 콘솔과 `LOG_DIR` 디렉토리에 있는 파일로 전송됩니다.

`REDIS_HOST` 와 `REDIS_PORT`는 **Orakl Network VRF** 마이크로서비스가 연결하는 [Redis](https://redis.io/)의 호스트와 포트를 나타냅니다. 기본값은 각각 `localhost` 와 `6379` 입니다.&#x20;

**Orakl Network VRF** 는 풍부한 REST API를 제공하지 않지만, `HEALTH_CHECK_PORT` 로 지정된 포트에서 제공되는 헬스 체크 엔드포인트 (`/`) 를 정의합니다.

`HOST_SETTINGS_LOG_DIR` 은 [Docker Compose 파일](https://github.com/Bisonai/orakl/blob/master/core/docker-compose.vrf.yaml)에서 사용되며, 수집된 로그 파일이 호스트에서 저장될 위치를 나타냅니다.

**Orakl Network VRF** 에서 발생하는 오류와 경고를 [Slack 웹훅을 통해 Slack 채널로 전송](https://api.slack.com/messaging/webhooks)할 수 있습니다. 웹훅 URL은 `SLACK_WEBOOK_URL` 환경 변수를 사용하여 설정할 수 있습니다.

## Launch

VRF 솔루션을 시작하기 전에 **Orakl Network API** 가 **Orakl Network VRF** 에서 VRF 키 및 리스너 설정을 로드할 수 있도록 액세스할 수 있어야 합니다.

**Orakl Network API** 가 정상적으로 동작하는 경우, VRF 마이크로서비스 (listener, worker, reporter)를 임의의 순서로 시작할 수 있습니다. 마이크로서비스는 BullMQ - job queue를 통해 서로 통신합니다.

```sh
yarn start:listener:vrf
yarn start:worker:vrf
yarn start:reporter:vrf
```

## Architecture

<figure><img src="../.gitbook/assets/orakl-network-vrf.png" alt=""><figcaption><p>Orakl Network VRF</p></figcaption></figure>

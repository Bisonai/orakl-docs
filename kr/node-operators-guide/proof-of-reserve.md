# Orakl Network Proof of Reserve

## Description

**Orakl Network Proof of Reserve** 는 금융 기관의 예비 자산을 확립하고 확인하기 위해 설계되었습니다. 이 서비스는 예비 데이터를 확인하기 위한 안전하고 감사 가능한 프로세스를 제공함으로써 투명성과 신뢰를 보장합니다. 이 서비스는 오프체인 및 온체인 과정을 통해 예비 자산을 확인하고 인증해줍니다.

준비금 증명(Proof of Reserve)은 어댑터와 어그리게이터의 쌍에 의해 정의되며, [Orakl Network Data Feed](./data-feed.md) 에서 재사용된 온체인 계약 구현을 통해 온체인에서 액세스할 수 있습니다. `AggregatorProxy` 는 읽기 요청을 `Aggregator` 컨트랙트로 리디렉션하는 보조 계약입니다. The Proof of Reserve의 `Aggregator` 컨트랙트는 모든 제출 값들을 보유하며 이 값들은 `AggregatorProxy` 컨트랙트를 통해 소비자에게 제공됩니다.

모든 준비금 증명에는 `heartbeat`(가장 적은 업데이트 간격)과 (`deviationTreshold`)(최소 편차 임곗값)을 설명하는 구성이 있습니다."

**Orakl Network Proof of Reserve** 는 간소화된 단일 프로세스 시스템으로 작동하며 크론 작업에 의해 실행됩니다. 먼저 Proof of Reserve `Aggregator contract` 컨트랙트에서 가장 최근의 `roundId` 와 `PoR value`를 검색합니다. 그 다음에는 `Heartbeat Check` 및 `Deviation Check` 의 조합을 통해 제출 대상 여부를 확인합니다. 어떤 조건이라도 충족되면 최종 단계는 `API resource` 에서 데이터를 가져와 다음 라운드를 `POR contract`에 보고합니다. 이 전체 과정은 `Proof of Reserve` 프로세스의 효율적이고 시기적절한 실행을 보장합니다.

해당 코드는 [`core` 디렉터리](https://github.com/Bisonai/orakl/tree/master/core/src/por) 에 위치해 있습니다.

## Configuration

**Orakl Network Proof of Reserve**를 시작하기 전에 [여러 환경 변수](https://github.com/Bisonai/orakl/blob/master/node/.env.example)를 지정해야 합니다. 환경 변수는 자동으로 .env 파일에서 로드됩니다.

```.env
# POR
POR_REPORTER_PK=
POR_CHAIN=
POR_PROVIDER_URL=
# (optional) defaults to 3000
POR_PORT=
```

- `POR_REPORTER_PK`: 지정된 POR 리포터의 pk, 집계기 계약에서 화이트리스트에 등록되어야 함
- `POR_CHAIN`: POR의 체인 이름 (`baobab` 또는 `cypress`)
- `POR_PROVIDER_URL`: 온체인에서 읽고 제출하는 데 사용할 JSON RPC URL
- `POR_PORT`: 헬스체크에 사용할 포트 (기본값은 `3000`)

## Launch

orakl 노드를 실행하기 전에 환경 변수를 설정하십시오. 자세한 내용은 [여기](https://github.com/Bisonai/orakl/blob/master/node/README.md)readme 파일에서 찾을 수 있습니다.

./node 경로에서 다음 명령을 실행하십시오.

```sh
task local:por
```

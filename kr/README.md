---
description: >-
  Orakl Network 는 분산형 오라클 네트워크로, 스마트 계약이 안전하게 오프체인 데이터와 다른 자원에 접근할 수 있도록 합니다.
---

# Introduction

## Installation

> 오라클 컨트랙트 버전 v0.1, v0.2는 Solidity 버전 ^0.8.20을 사용합니다. npm 패키지인 @bisonai/orakl-contract의 버전은 변경 사항을 인식하기 위한 내부 버전입니다.

```
yarn add @bisonai/orakl-contracts@v2.0.2
```

이 페이지의 나머지 부분에서는 [서비스](./#services) 와 [결제 옵션](./#payment) 에 대해 설명합니다.

## Services

- [Verifiable Random Function (VRF)](developers-guide/vrf.md)
- [Request-Response](developers-guide/request-response.md)
- [Data Feed](developers-guide/data-feed.md)

### Verifiable Random Function (VRF)

**Verifiable Random Function (VRF)** 은 블록체인 상에서 검증 가능하고 투명한 방식으로 난수를 생성할 수 있게 해줍니다. 이는 게임 및 도박 애플리케이션과 같은 다양한 사용 사례에서 공정하고 편향되지 않은 난수 생성기가 필수적인 경우에 유용합니다.

Orakl Network VRF에 대한 자세한 정보는 [VRF 사용 개발자 가이드](developers-guide/vrf.md)에서 확인하실 수 있습니다. VRF를 즉시 사용하시려는 경우 [Orakl Network VRF를 사용한 예제 Hardhat 프로젝트](https://github.com/Bisonai/vrf-consumer) 를 참고하시기 바랍니다.

### Request-Response

**Request-Response** 는 오프체인에서 정보를 조회하고 스마트 계약으로 가져올 수 있게 해줍니다.

Orakl Network Request-Response에 대한 자세한 정보는 [Request-Response 사용 개발자 가이드](developers-guide/request-response.md)에서 확인하실 수 있습니다. Request-Response의 기본 개념을 이해하신 후, [Orakl Network Request-Response를 사용한 예제 Hardhat 프로젝트](https://github.com/Bisonai/vrf-consumer)를 참고하시면 도움이 될 것입니다.

### Data Feed

**Data Feed** 는 최신 오프체인 정보에 직접적인 온체인 액세스를 제공합니다. 데이터는 분산되고 안전한 방식으로 일련의 분산 및 신뢰할 수 있는 운영자들을 통해 수집됩니다.

Orakl Network Data Feed에 대한 자세한 정보는 [Data Feed 사용에 대한 개발자 안내서](developers-guide/data-feed.md)에서 확인하실 수 있습니다. 실제로 Orakl Network Data Feed를 체험해보시려면, [Orakl Network Data Feed를 활용한 예제 Hardhat 프로젝트](https://github.com/Bisonai/data-feed-consumer)를 살펴보시는 것을 권장해드립니다.

### Proof Of Reserve

**예비 자금 증명** 방법은 특히 탈중앙화 금융(DeFi) 및 블록체인 시스템에 참여하는 금융 기관들에 의한 검증으로 작동합니다.

Orakl Network 예비 자금 증명에 대한 자세한 정보는 [예비 자금 증명 사용 방법에 대한 개발자 가이드](developers-guide/proof-of-reserve.md)에서 찾을 수 있습니다. Orakl Network 예비 자금 증명을 실제로 경험해보려면 [Orakl Network 데이터 피드를 사용한 Hardhat 프로젝트의 예제](https://github.com/Bisonai/data-feed-consumer)를 확인하는 것을 권장드립니다.

## Payment & Account Types

Orakl Network에서는 [Prepayment](developers-guide/prepayment.md) 라는 주요 결제 방법을 제공하고 있습니다. 이 방법을 통해 사용자는 Orakl Network 계정에 일정 금액의 $KLAY를 예치하고, 이를 사용하여 Orakl Network VRF 또는 Orakl Network Request-Response를 요청할 수 있습니다. Orakl Network는 Prepayment 방법을 지원하는 두 가지 다른 계정 유형을 제공합니다:

- [Permanent account](./#permanent-account)
- [Temporary account](./#temporary-account)

### Permanent account

**Permanent account(영구 계정)** 은 Orakl Network의 서비스를 선결제(Prepayment) 하고, 이를 Orakl Network와 상호작용할 때 사용할 수 있는 계정입니다. 영구 계정은 별도의 스마트 계약으로 구성됩니다. 사용자는 이 계정을 통해 직접 자금에 접근하지 않고도 Orakl Network 서비스를 요청할 수 있는 일련의 소비자 스마트 계약을 정의할 수 있습니다. 현재 VRF와 Request-Response를 요청하기 위한 권장 방법은 영구 계정입니다. Prepayment 결제 방법이나 영구 계정에 대해 자세히 알아보시려면, [Prepayment 사용자 안내서](developers-guide/prepayment.md) 를 참고하시기 바랍니다.

### Temporary account

**Temporary account(임시 계정)** 은 Orakl Network의 일시적인 사용자를 위해 설계된 계정입니다. 사용자는 서비스 요청 시점에 해당 계정을 사용하여 서비스에 대한 지불을 진행합니다. 임시 계정은 Prepayment 계약 내에서 요청이 이행되거나 잔액이 인출될 때까지 존재합니다. VRF와 Request-Response를 모두 요청하는 데 임시 계정을 사용할 수 있습니다.

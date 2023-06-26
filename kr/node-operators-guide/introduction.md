---
description: Brief Description Of The Orakl Network For Node Operators
---

# Introduction

Orakl Network는 온체인(on-chain) 및 오프체인(off-chain) 계산을 활용하여 다음과 같은 솔루션을 제공하는 [하이브리드 스마트 계약](https://blog.chain.link/hybrid-smart-contracts-explained/) 으로 구성된 서비스입니다:

* [Verifiable Random Function (VRF)](../developers-guide/vrf.md)
* [Request-Response](../developers-guide/request-response.md)
* [Data Feed](../developers-guide/data-feed.md)

## On-Chain Orakl Network

[`contracts` directory](https://github.com/Bisonai/orakl/tree/master/contracts) 에는 모든 관련 스마트 계약, 테스트 및 배포 스크립트가 포함되어 있습니다. 노드 운영자는 `contracts`디렉토리의 내용에 대해 걱정할 필요는 없지만, 노드를 올바르게 설정하기 위해 최신 스마트 계약 주소와 최신 설정에 대한 정보를 알고 있어야 합니다. 필요한 경우, 우리는 노드 운영자에게 자세한 정보를 제공할 것입니다.

## Off-Chain Orakl Network

오프체인 부분은 다양한 보조 마이크로 서비스와 주요 오라클 솔루션으로 이루어져 있습니다:

* [Orakl Network API](api.md)
* [Orakl Network CLI](broken-reference/)
* [Orakl Network Fetcher](fetcher.md)
* [Orakl Network VRF](vrf.md)
* [Orakl Network Request-Response](request-response.md)
* [Orakl Network Data Feed](data-feed.md)
* [Orakl Network Delegator](delegator.md)
* [Helm Chart Infra Setup](helmchart.md)

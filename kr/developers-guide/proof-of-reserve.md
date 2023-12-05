# Proof of Reserve

Orakl Network의 Proof of Reserve를 쉽게 이해하고자 한다면 [`data-feed-consumer`](https://github.com/Bisonai/data-feed-consumer)의 예시 리포지터리를 참조하십시오. Proof of Reserve의 온체인 구현은 Aggregator 및 Aggregator Proxy와 유사합니다.

## POR이란?

**Orakl Network의 Proof of Reserve (PoR)**는 Orakl Network 생태계 내에서 신뢰와 투명성을 높이는 핵심 요소입니다. PoR은 실물자산을 안전하고 감사 가능한 절차를 통해 확인합니다. 첫 POR인 GPC Proof of Reserve는 Gold Pegged Coin을 위해 발행된 비대체 토큰(NFT)을 나타냅니다.

### Cypress의 POR

<table><thead><tr><th width="157">PoR</th><th>Aggregator</th><th>AggregatorProxy</th><th>Heartbeat (m)</th></tr></thead><tbody>
    <tr>
        <td>GPC (Gold Pegged Coin)</td>
        <td><a href="https://www.klaytnfinder.io/account/0xb5e91e5CE0B8e6fc3029b4E9ce057675a2c96dd1">0xb5e91e5CE0B8e6fc3029b4E9ce057675a2c96dd1</a></td>
        <td><a href="https://www.klaytnfinder.io/account/0x9FbA23B10692cB3fa6Fea09834855ACc597BD180">0x9FbA23B10692cB3fa6Fea09834855ACc597BD180</a></td>
        <td>60</td></tr></tr></tbody></table>

### Baobab의 POR

**주의:** Baobab의 데이터는 테스팅 목적일 뿐이며 실제 데이터와는 무관합니다.

<table><thead><tr><th width="157">PoR</th><th>Aggregator</th><th>AggregatorProxy</th><th>Heartbeat (m)</th></tr></thead><tbody>
    <tr>
        <td>GPC (Gold Pegged Coin)</td><td><a href="https://baobab.klaytnfinder.io/account/0x58798D6Ca40480DF2FAd1b69939C3D29d91b60d3">0x58798D6Ca40480DF2FAd1b69939C3D29d91b60d3</a></td>
        <td><a href="https://baobab.klaytnfinder.io/account/0x821179a6d4F62fa6979BF42bEb9eE16a1F14C4eD">0x821179a6d4F62fa6979BF42bEb9eE16a1F14C4eD</a></td>
        <td>2</td></tr></tr></tbody></table>

## POR 어그리게이터 컨트랙트 읽는법

Orakl Network의 Proof of Reserve (PoR)는 두 가지 주요 스마트 컨트랙트인 'Aggregator'와 'AggregatorProxy'로 구성됩니다. 두가지 스마트 컨트랙트는 특정 데이터 피드를 나타내는 쌍을 형성하며 가격 피드에 대한 지속적인 액세스를 가능케 합니다. 'Aggregator'는 오프체인에서 정기적인 업데이트를 받아 정확하고 최신의 가격 정보를 보장합니다. 'AggregatorProxy'는 제출된 데이터에 액세스하기 위한 일관된 API 역할을 합니다.

더 자세한 이해를 위해서는 [데이터 피드](./data-feed.md) 문서를 참조하십시오. 이 문서는 'Aggregator' 및 'AggregatorProxy' 간의 아키텍처, 절차 및 관련 정보에 대한 포괄적인 정보를 제공하며 PoR 기능을 이해하는 데 도움이 됩니다.

'Aggregator' 컨트랙트에서 예비 자금을 읽는 방법에 대한 자세한 내용은 [`데이터 피드 문서`](./data-feed#initialization)를 참조하십시오.

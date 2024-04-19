# 프로젝트 설명

이 프로젝트는 데이터 피드의 실용적인 사용을 보여주는 바이너리 옵션을 위한 간단한 탈중앙화 애플리케이션(DApp)입니다

## 코드 저장소

이 프로젝트의 코드는 [binary option orakl](https://github.com/Bisonai/orakl-demo-binary-option)에서 확인할 수 있습니다. 자세한 지침은 readme.md 파일을 참조하십시오.

# 고지

바이너리 옵션 거래가 일부 지역에서 불법일 수 있음을 인지하시기 바랍니다. 이 DApp은 순수한 교육 목적으로만 사용됩니다.

# 핵심 개념

사용자가 플랫폼에 지갑을 연결하면 30 포인트가 할당됩니다. 이 포인트는 특정 페어의 가격 변동을 추측하는 데 사용되며, 상승할지 하락할지를 예측합니다. DApp은 latestRoundData()를 가져 와서 베팅을 놓은 시점의 가격과 비교합니다.

페어의 최신 가격 정보에 액세스하려면 Orakl 네트워크 데이터 피드에서 사용 가능한 프록시 계약 목록을 참조하십시오.

```solidity
function latestRoundData() external view returns (uint64 id, int256 answer, uint256 updatedAt) {
    return feed.latestRoundData();
}
```

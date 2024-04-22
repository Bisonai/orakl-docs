# 프로젝트 설명

이 프로젝트는 Orakl-VRF(검증 가능한 랜덤 함수) 서비스의 사용법을 보여주기 위한 간단한 "동전 던지기" 게임입니다

## 코드 저장소

이 프로젝트의 코드는 [Flip Coin Orakl](https://github.com/Bisonai/orakl-demo-flip-coin)에서 확인할 수 있습니다. 자세한 지침은 readme.md 파일을 참조하십시오.

### 게임 개념

참가자는 간단한 게임에서 금액을 걸고 머리 또는 꼬리를 선택합니다. 성공적인 예측은 베팅을 두 배로 만들고, 잘못된 예측은 전체 베팅을 잃게 됩니다.

### 기능

이 게임은 Orakl 네트워크의 VRF 서비스를 활용하여 동전 던지기의 무작위 결과를 생성합니다.

## 매개변수 설정

생성자는 VRF 서비스를 호출하기 위한 모든 필요한 매개변수를 초기화합니다:

```solidity
constructor(
    uint64 accountId,
    address coordinator,
    bytes32 keyHash
) VRFConsumerBase(coordinator) {
    COORDINATOR = IVRFCoordinator(coordinator);
    sAccountId = accountId;
    sKeyHash = keyHash;
}
```

## 동전 던지기 실행

`flip()` 함수는 동전 던지기 결과를 결정하기 위해 VRF에서 무작위 숫자를 요청하고 추적을 위해 베팅 세부 정보를 기록합니다.

## 결과 처리

`fulfillRandomWords()` 함수는 Orakl VRF 서비스의 결과를 처리합니다. 결과에 따라 승리 금액이 계산되고 잔액이 조정됩니다.

## 승리금 청구

플레이어는 승리금을 청구하기 위해 `claim()` 함수를 사용하여 승리한 잔액을 계정으로 이체할 수 있습니다.

## 세금 수수료 메커니즘

계약에는 소유자가 setTaxFee 함수를 사용하여 수수료를 설정할 수 있는 세금 수수료 메커니즘이 포함되어 있습니다. 또한 소유자는 withdraw 함수를 사용하여 계약 잔액에서 자금을 인출할 수 있습니다.

이 프로젝트는 게임 응용 프로그램에 Orakl-VRF를 통합하는 예시로, 안전하고 검증 가능한 무작위 결과를 제공하는 능력을 보여줍니다.

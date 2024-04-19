# 프로젝트 설명

이 프로젝트는 사용자가 무작위 NFT(비획득 가능 토큰)를 청구할 기회가 있는 NFT 상자를 구매하는 GameFi 프로젝트의 일반적인 시나리오를 보여줍니다. 이 DApp 데모에서 사용자는 무료로 NFT 상자를 청구할 수 있습니다.

NFT 계약은 Orakl VRF(검증 가능한 랜덤 함수) 서비스를 활용하여 보상 NFT의 ID에 해당하는 1에서 10 사이의 무작위 숫자를 생성합니다.

## 코드 저장소

이 프로젝트의 코드는 [mystery box orakl](https://github.com/Bisonai/orakl-demo-mystery-box)에서 이용할 수 있습니다. 자세한 지침은 readme.md 파일을 참조하십시오.

## NFT 상자 계약

이 계약은 NFT에 대한 ERC-721 표준을 준수하며 추가 기능이 포함되어 있습니다.

### 상자 열기

openBox 함수는 Orakl VRF 서비스에서 무작위 숫자를 요청하고 NFT를 태우며 사용자에게 해당하는 NFT를 보상합니다.

```solidity
function openBox(uint256 _tokenId) public {
    _requireOwned(_tokenId);
    uint256 requestId = requestRandomWords();
    requestIdToPlayer[requestId] = msg.sender;
    _burn(_tokenId);
}
```

### 무작위 숫자 처리

fulfillRandomWords 함수는 Orakl VRF 서비스에서 무작위 숫자를 받아 해당하는 NFT를 생성합니다.

```solidity
function fulfillRandomWords(
    uint256 requestId,
    uint256[] memory randomWords
) internal override {
    uint id = randomWords[0] % 10;
    address player = requestIdToPlayer[requestId];
    delete requestIdToPlayer[requestId];
    NFT.mint(player, id, 1, "0x");
}
```

## NFT 계약

이 계약은 NFT에 대한 ERC-1155 표준을 따르며 mint 함수에 대한 액세스 제어가 포함되어 있습니다.

### 단일 Mint

```solidity
function mint(
    address account,
    uint256 id,
    uint256 amount,
    bytes memory data
) public onlyRole(MINTER_ROLE) {
    _mint(account, id, amount, data);
}
```

### 일괄 Mint

```solidity
function mintBatch(
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
) public onlyRole(MINTER_ROLE) {
    _mintBatch(to, ids, amounts, data);
}
```

### 참고

보상 NFT를 생성하도록 상자 계약에 minter 역할을 부여하십시오.

이 프로젝트는 Orakl VRF가 GameFi 생태계 내에서 NFT 보상에 무작위성을 도입하는 방법을 보여주며, 사용자의 게임 경험을 향상시킵니다.

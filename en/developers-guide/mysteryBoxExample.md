---
Description: This is a very popular use case for GameFi projects
You sell a nftbox
User buy the box and open the box for a random nft
In this demo dapp, you can claim the box for free
The nft contract uses orakl VRF service to generate a random number from 1 - 10, this is th ID of the reward Nft
---

1. The NFT box contract

This is a typical ERC 721 NFT contract, with extra functions

+ The `openBox` function implements the `requestRandomWords` from orakl VRF service and burn the NFT

```
    function openBox(uint256 _tokenId) public {
        _requireOwned(_tokenId);
        uint256 requestId = requestRandomWords();
        requestIdToPlayer[requestId] = msg.sender;
        _burn(_tokenId);
    }
```

+ The function `fulfillRandomWords` mint an NFT with the random ID returned by VRF service

```
    function fulfillRandomWords(
        uint256 requestId /* requestId */,
        uint256[] memory randomWords
    ) internal override {
        uint id = randomWords[0] % 10;
        address player = requestIdToPlayer[requestId];
        delete requestIdToPlayer[requestId];
        NFT.mint(player, id, 1, "0x");
    }
```

2. The NFT contract

This is a typical ERC 1155 contract, with access control for the mint function
`import "@openzeppelin/contracts/access/AccessControl.sol";`

Only users with minter role can `mint` or `mintBatch`

```
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyRole(MINTER_ROLE) {
        _mint(account, id, amount, data);
    }
```

```
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyRole(MINTER_ROLE) {
        _mintBatch(to, ids, amounts, data);
    }

```

---
Note: you need to grant minter role for the box contract in order for it to mint the reward
---
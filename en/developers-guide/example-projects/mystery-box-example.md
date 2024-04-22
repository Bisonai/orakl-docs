# Project Description

This project showcases a common scenario in GameFi projects where users purchase NFT (Non-Fungible Token) boxes with the chance to claim a random NFT. In this DApp demo, users can claim the NFT box for free.

The NFT contract utilizes the Orakl VRF (Verifiable Random Function) service to generate a random number between 1 and 10, corresponding to the ID of the rewarded NFT.

## Code repository

The code for this project is available in [mystery box orakl](https://github.com/Bisonai/orakl-demo-mystery-box). Refer to the readme.md file for detailed instructions on forking the game.

## NFT Box Contract

This contract complies with the ERC-721 standard for NFTs and includes additional features.

### Opening a Box

The openBox function requests a random number from the Orakl VRF service, burns the NFT, and rewards the user with the corresponding NFT.

```solidity
function openBox(uint256 _tokenId) public {
    _requireOwned(_tokenId);
    uint256 requestId = requestRandomWords();
    requestIdToPlayer[requestId] = msg.sender;
    _burn(_tokenId);
}
```

### Handling Random Number

The fulfillRandomWords function receives the random number from the Orakl VRF service and mints the corresponding NFT.

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

## NFT Contract

This contract follows the ERC-1155 standard for NFTs and includes access control for the mint function.

### Single Mint

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

### Batch Mint

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

### Note

Grant the minter role to the box contract to enable it to mint the rewarded NFT.

This project demonstrates how Orakl VRF can introduce randomness into NFT rewards within GameFi ecosystems, enhancing user gaming experiences.


Project Description:

This project represents a prevalent use case within GameFi projects where NFT (Non-Fungible Token) boxes are sold to users who can then claim the box for a chance to receive a random NFT. In this demonstration DApp, users have the opportunity to claim the NFT box for free.

The NFT contract utilizes the Orakl VRF (Verifiable Random Function) service to generate a random number within the range of 1 to 10, which corresponds to the ID of the rewarded NFT.

1. NFT Box Contract:

This contract adheres to the ERC-721 standard for NFTs but includes additional functionalities.

The openBox function is responsible for initiating a request to the Orakl VRF service to obtain a random number and then burns the NFT.
```
function openBox(uint256 _tokenId) public {
    _requireOwned(_tokenId);
    uint256 requestId = requestRandomWords();
    requestIdToPlayer[requestId] = msg.sender;
    _burn(_tokenId);
}
```
The fulfillRandomWords function receives the random number from the Orakl VRF service and mints an NFT with the corresponding ID.
```
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
2. NFT Contract:

This contract follows the ERC-1155 standard for NFTs and incorporates access control for the mint function.

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
Note: It's imperative to grant the minter role for the box contract to enable it to mint the rewarded NFT.

This project exemplifies the integration of Orakl VRF to introduce randomness into NFT rewards within GameFi ecosystems, enhancing the gaming experience for users.
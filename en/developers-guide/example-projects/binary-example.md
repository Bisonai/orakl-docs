# Project Description

This project involves the development of a simple decentralized application (DApp) for binary options, showcasing the practical use of data feeds.

## Code repository

The code for this project is available in [binary option orakl](https://github.com/Bisonai/orakl-demo-binary-option). Refer to the readme.md file for detailed instructions on forking the game.

# Disclaimer

Please be aware that binary options trading may be illegal in some jurisdictions. This DApp is purely for educational purposes.

# Key Concept

Upon connecting your wallet to the platform, users are allocated 30 points. These points are used to speculate on the price movements of specified pairs, predicting whether they will rise or fall. The DApp fetches the latestRoundData() and compares it with the price at the time of placing the bet.

To access the latest price information for a pair, consult the list of proxy contracts available on the Orakl Network Data Feed.

```solidity
function latestRoundData() external view returns (uint64 id, int256 answer, uint256 updatedAt) {
    return feed.latestRoundData();
}
```

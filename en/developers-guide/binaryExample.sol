Project Description:
This project entails the development of a straightforward binary option decentralized application (DApp) aimed at illustrating the practical application of utilizing data feeds.

Disclaimer:
It's important to note that binary options may be deemed illegal in certain jurisdictions. This DApp is intended solely for educational purposes.

Key Concept:
Upon connecting your wallet to the platform, users will be endowed with 30 points. These points are then utilized to speculate on the price movements of specified pairs, predicting whether they will rise or fall. The DApp functions by accessing the latestRoundData() and contrasting it with the price at the time of placing the bet.

For accessing the latest price information of a pair, refer to the list of proxy contracts available at the following link: Orakl Network Data Feed.

```
function latestRoundData() external view returns (uint64 id, int256 answer, uint256 updatedAt) {
        return feed.latestRoundData();
    }

```


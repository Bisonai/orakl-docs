---
Description: A simple binary option dapp to demonstrate the use case of datafeed
---

---
Disclaimer: Binary option is illegal in some contries. This daap is for educational and purpose only
---

---
Main idea:
You have 30 points when you connect wallet to the platform
You bet on prices of given pairs to go up or down
The dapp will read `latestRoundData()` and compare it to the price when you make the bet
---

You can find the list of proxy contracts here:

https://orakl.network/data-feed

To get latest price of a pair

```
function latestRoundData() external view returns (uint64 id, int256 answer, uint256 updatedAt) {
        return feed.latestRoundData();
    }

```


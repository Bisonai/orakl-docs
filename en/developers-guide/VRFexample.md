---
description: A simple flip the coin game to demonstrate how to use orakl-vrf
---

The code can be found here: https://github.com/Bisonai/flip-coin-orakl
If you want to fork the whole game, please check the `readme.md` file

1. the Idea of the game
This is simple flip-the-coin for all or nothing game.
First, choose the amount you want to bet, 
Then, choose head or tail
If you win, you double you bet, if you lose, you lose the bet amount

2. How does it work:
This game utilizes the VRF service of orakl network to get a random result for head or tail

All needed parameter to call VRF service are defined in the constructor

```
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

Inside the `flip()` function, we call to VRF to request a random number for even or odd

```
function flip(uint256 bet) public payable {
        uint256 amount = msg.value;
        require(msg.sender.balance >= amount, "Insufficient account balance");
        uint256 betAmount = (msg.value / (1000 + taxFee)) * 1000;
        uint256 fee = betAmount * (taxFee / 1000);
        uint256 neededBalance = (betAmount * 2 + fee + totalRemainBalance); // balance need to pay for player
        require(
            address(this).balance >= neededBalance,
            "FlipCoin: Insufficient account balance"
        );
        uint256 requestid = requestRandomWords();
        //uint256 requestid =1;
        players[msg.sender].push(requestid);
        requestInfors[requestid].player = msg.sender;
        requestInfors[requestid].bet = bet;
        requestInfors[requestid].betAmount = betAmount;

        totalRequest += 1;
        playerInfors[msg.sender].total += 1;

        emit Flip(msg.sender, bet, betAmount, requestid);
    }

```
Orakl VRF service return the result via the `fulfillRandomWords`

```
function fulfillRandomWords(
        uint256 requestId /* requestId */,
        uint256[] memory randomWords
    ) internal override {
        uint result = randomWords[0] % 2;
        requestInfors[requestId].result = result;
        requestInfors[requestId].hasResult = true;
        uint bet = requestInfors[requestId].bet;
        uint256 betAmount = requestInfors[requestId].betAmount;
        address player = requestInfors[requestId].player;
        //
        if (bet == result) //win
        {
            playerInfors[player].winCount += 1;
            playerInfors[player].balance += betAmount * 2;
            totalWinCount += 1;
            totalRemainBalance += betAmount * 2;
        }
        emit Result(player, requestId, result, randomWords[0]);
    }
```
The winning balance is stored under `playerInfor`, you can claim your winnings with the `claim` function

```
function claim() public {
        playerInfor storage playerinfor = playerInfors[msg.sender];
        uint256 amount = playerinfor.balance;
        require(amount > 0, "Insufficient account balance");
        require(
            address(this).balance >= amount,
            "FlipCoin: Insufficient account balance"
        );
        playerinfor.balance = 0;
        totalRemainBalance -= amount;
        payable(msg.sender).transfer(amount);
        emit Claim(msg.sender, amount);
    }
```

The contract also have a `taxfee` machanism which can be set by `owner`

```
function setTaxFee(uint256 newFee) public onlyOwner {
        require(newFee <= taxFeeMax, "Fee out of range");
        taxFee = newFee;
        emit SetTaxFee(msg.sender, newFee);
    }

```
```
function withdraw(uint256 amount) public onlyOwner {
        uint256 availableBalance = address(this).balance - totalRemainBalance;
        require(
            availableBalance >= amount,
            "FlipCoin: Insufficient account balance"
        );
        payable(msg.sender).transfer(amount);
    }
```
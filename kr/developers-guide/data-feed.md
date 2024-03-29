---
description: Continuous stream of off-chain data to your smart contract
---

# Data Feed

**Orakl Network Data Feed** 사용 예제는 예제 저장소인 [`data-feed-consumer`](https://github.com/Bisonai/data-feed-consumer)에서 자세히 확인하실 수 있습니다.

## What is Data Feed?

Orakl Network 데이터 피드는 스마트 계약에서 온체인으로 접근할 수 있는 안전하고 신뢰할 수 있는 탈중앙화된 오프체인 데이터의 원천입니다. 데이터 피드는 미리 정의된 시간 간격으로 업데이트되며, 데이터 값이 미리 정의된 임계값을 초과하는 경우에도 업데이트되어 데이터의 정확성과 최신성을 유지합니다. 데이터 피드는 다양한 온체인 프로토콜에서 사용될 수 있습니다:

- Lending and borrowing(대출 및 차입)
- Mirrored assets(기존 자산의 가치와 움직임을 반영한 디지털 자산)
- Stablecoins(스테이블코인)
- Asset management(자산 관리)
- Options and futures(옵션 및 선물)
- 그 외에도 다양한 용도로 활용될 수 있습니다!

Orakl 데이터 피드에는 무료로 사용할 수 있는 다양한 데이터 피드가 포함되어 있습니다. 현재 지원되는 데이터 피드는 아래 표에서 확인하실 수 있습니다.

### Supported Data Feeds on Cypress

<table><thead><tr><th width="157">Data Feed</th><th>Aggregator</th><th>AggregatorProxy</th><th>Heartbeat (ms)</th></tr></thead><tbody><tr><td>BTC-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x21df0fDC25cd276FAec7a081159788a2Ec52e040">0x21df0fdc25cd276faec7a081159788a2ec52e040</a></td><td><a href="https://www.klaytnfinder.io/account/0xc0516486DD0837a8Dd6E502F9134Ff3c421377AC">0xc0516486dd0837a8dd6e502f9134ff3c421377ac</a></td><td>15,000</td></tr><tr><td>ETH-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x0ee317740EA515D02587393AA32CbB6686110CAE">0x0ee317740ea515d02587393aa32cbb6686110cae</a></td><td><a href="https://www.klaytnfinder.io/account/0x37C637922D6F5F62e067588A75E9d59c26cd64c3">0x37c637922d6f5f62e067588a75e9d59c26cd64c3</a></td><td>15,000</td></tr><tr><td>KLAY-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x955bd135ABBc0eB0D022556602112A9Ec456d41d">0x955bd135abbc0eb0d022556602112a9ec456d41d</a></td><td><a href="https://www.klaytnfinder.io/account/0x33D6ee12D4ADE244100F09b280e159659fe0ACE0">0x33d6ee12d4ade244100f09b280e159659fe0ace0</a></td><td>15,000</td></tr><tr><td>MATIC-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x40E97db6E366eF067020A0d98FB3E427299397ba">0x40e97db6e366ef067020a0d98fb3e427299397ba</a></td><td><a href="https://www.klaytnfinder.io/account/0xC51B1ec2e0a88c7156Af634cB46F83525F00F784">0xc51b1ec2e0a88c7156af634cb46f83525f00f784</a></td><td>15,000</td></tr><tr><td>SOL-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x7ec03AC011101eC050df4eEB9e3383608D81fcC1">0x7ec03ac011101ec050df4eeb9e3383608d81fcc1</a></td><td><a href="https://www.klaytnfinder.io/account/0x09B387816847AB0702aFb4e4FfA43240dcA20Bc6">0x09b387816847ab0702afb4e4ffa43240dca20bc6</a></td><td>15,000</td></tr><tr><td>USDC-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x138eAA152f9702076cEA9CB420Fa763049d44251">0x138eaa152f9702076cea9cb420fa763049d44251</a></td><td><a href="https://www.klaytnfinder.io/account/0x0Eb4cA5f008080191a7780101118b5a26e9925E4">0x0eb4ca5f008080191a7780101118b5a26e9925e4</a></td><td>15,000</td></tr><tr><td>DAI-USDT</td><td><a href="https://www.klaytnfinder.io/account/0xc20fA4a7Ba95Ec7E4CbB9458403365210EFa09B5">0xc20fa4a7ba95ec7e4cbb9458403365210efa09b5</a></td><td><a href="https://www.klaytnfinder.io/account/0xC12f7c66b3F192b074Ff883803bAb7571bd6a25D">0xc12f7c66b3f192b074ff883803bab7571bd6a25d</a></td><td>15,000</td></tr><tr><td>DOT-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x38362F1a2d7c223a132018505A35a87A63f7840A">0x38362f1a2d7c223a132018505a35a87a63f7840a</a></td><td><a href="https://www.klaytnfinder.io/account/0x90708e35E62dea8024dE3672Ca05a4626D5d5e9C">0x90708e35e62dea8024de3672ca05a4626d5d5e9c</a></td><td>15,000</td></tr><tr><td>BNB-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x47c63Bca3Fa9D3eA7F9Bc7C48C14f691d50FB872">0x47c63bca3fa9d3ea7f9bc7c48c14f691d50fb872</a></td><td><a href="https://www.klaytnfinder.io/account/0x7aa7bD1A2AD16527293200a4Fecc9548b2822A59">0x7aa7bd1a2ad16527293200a4fecc9548b2822a59</a></td><td>15,000</td></tr><tr><td>TRX-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x035A27A2797106Dc68606cA054dA5429750F0d86">0x035a27a2797106dc68606ca054da5429750f0d86</a></td><td><a href="https://www.klaytnfinder.io/account/0x28A69574604E01c86C116Fe4C6EdE28CDbe66b4B">0x28a69574604e01c86c116fe4c6ede28cdbe66b4b</a></td><td>15,000</td></tr><tr><td>MNR-KRW</td><td><a href="https://www.klaytnfinder.io/account/0xfccB3925817e0dCFEE28343769Bbe203D8443a98">0xfccb3925817e0dcfee28343769bbe203d8443a98</a></td><td><a href="https://www.klaytnfinder.io/account/0x61be615807fC5306E1C691D290a422aF7995B4C5">0x61be615807fc5306e1c691d290a422af7995b4c5</a></td><td>15,000</td></tr><tr><td>ADA-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x235587EA94b2fe15FfFf0577303E5F0Cf13C29Ab">0x235587EA94b2fe15FfFf0577303E5F0Cf13C29Ab</a></td><td><a href="https://www.klaytnfinder.io/account/0x04a77b347d1e0FD6FA9af328aB0232F3F2Be05C0">0x04a77b347d1e0FD6FA9af328aB0232F3F2Be05C0</a></td><td>15,000</td></tr><tr><td>ATOM-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x153A604Ce0d3Fee619fb9A1F484d885001D1c13F">0x153A604Ce0d3Fee619fb9A1F484d885001D1c13F</a></td><td><a href="https://www.klaytnfinder.io/account/0x1eD814571AB8FA61F546dDb92125d22dc7dAd150">0x1eD814571AB8FA61F546dDb92125d22dc7dAd150</a></td><td>15,000</td></tr><tr><td>AVAX-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x700d467Ff6727D99409cBE13e1D3b24A4F8981Df">0x700d467Ff6727D99409cBE13e1D3b24A4F8981Df</a></td><td><a href="https://www.klaytnfinder.io/account/0x5E64449c9088Be970608856Fb817dAc364bf63A5">0x5E64449c9088Be970608856Fb817dAc364bf63A5</a></td><td>15,000</td></tr><tr><td>DOGE-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x92d6e3893B8853184D167780c7eB0D784F0ebe91">0x92d6e3893B8853184D167780c7eB0D784F0ebe91</a></td><td><a href="https://www.klaytnfinder.io/account/0x0dcb00FBDd314dbd524927D769cd2da0092Ab644">0x0dcb00FBDd314dbd524927D769cd2da0092Ab644</a></td><td>15,000</td></tr><tr><td>FTM-USDT</td><td><a href="https://www.klaytnfinder.io/account/0xFf369500111F0CE541A67D84bCB326604099a066">0xFf369500111F0CE541A67D84bCB326604099a066</a></td><td><a href="https://www.klaytnfinder.io/account/0x6be0DA4Fc7b9ffB1254EA118ee2a8Fa018DB15f4">0x6be0DA4Fc7b9ffB1254EA118ee2a8Fa018DB15f4</a></td><td>15,000</td></tr><tr><td>LTC-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x570D233652001fEaE9Ee1D859D51BdA9221444C1">0x570D233652001fEaE9Ee1D859D51BdA9221444C1</a></td><td><a href="https://www.klaytnfinder.io/account/0x31144fAac15241aB56434740ea8C32F626DDE575">0x31144fAac15241aB56434740ea8C32F626DDE575</a></td><td>15,000</td></tr><tr><td>PAXG-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x384C4A7ee7B8Ef8D6a46E2f262581632EF06E313">0x384C4A7ee7B8Ef8D6a46E2f262581632EF06E313</a></td><td><a href="https://www.klaytnfinder.io/account/0x7E418fE88A22Dbb71bb81979A0d54EF4e8Fade73">0x7E418fE88A22Dbb71bb81979A0d54EF4e8Fade73</a></td><td>15,000</td></tr><tr><td>SHIB-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x528bb9cc2dCfDd98F712A60B54120fa4F63aAf0F">0x528bb9cc2dCfDd98F712A60B54120fa4F63aAf0F</a></td><td><a href="https://www.klaytnfinder.io/account/0xBb05a3cbe50cF725be9302539bFA502F78D4236E">0xBb05a3cbe50cF725be9302539bFA502F78D4236E</a></td><td>15,000</td></tr><tr><td>UNI-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x58B40391BC5bF647EB8Aa2CEF426950fC644d6BC">0x58B40391BC5bF647EB8Aa2CEF426950fC644d6BC</a></td><td><a href="https://www.klaytnfinder.io/account/0x40F0Ef1d120526712cf3AF77CF14348b19b83EAe">0x40F0Ef1d120526712cf3AF77CF14348b19b83EAe</a></td><td>15,000</td></tr><tr><td>XRP-USDT</td><td><a href="https://www.klaytnfinder.io/account/0xe2e2D78eF5ec2158AFf05472C8C65fdB994AC8E4">0xe2e2D78eF5ec2158AFf05472C8C65fdB994AC8E4</a></td><td><a href="https://www.klaytnfinder.io/account/0xc73665899A0b82f10D40Ea072C7A3a6F3a1c8d3D">0xc73665899A0b82f10D40Ea072C7A3a6F3a1c8d3D</a></td><td>15,000</td></tr><tr><td>JOY-USDT</td><td><a href="https://www.klaytnfinder.io/account/0x2c293dbe54eCfbE3104cf57C526A7d468ec6793b">0x2c293dbe54eCfbE3104cf57C526A7d468ec6793b</a></td><td><a href="https://www.klaytnfinder.io/account/0xd15ad2c20a9ef664744fb0ad11e5f78b09d44aa2">0xd15ad2c20a9ef664744fb0ad11e5f78b09d44aa2</a></td><td>15,000</td></tr></tbody></table>

### Supported Data Feeds on Baobab

<table><thead><tr><th width="159">Data Feed</th><th width="218">Aggregator</th><th width="255">AggregatorProxy</th><th>Heartbeat (ms)</th></tr></thead><tbody><tr><td>BTC-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xE747418f2fe0F5794c5105f718b59b283E1B5e07">0xE747418f2fe0F5794c5105f718b59b283E1B5e07</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x4b0687ce6eC3Fe6c019467c744D0C563643BdFa4">0x4b0687ce6eC3Fe6c019467c744D0C563643BdFa4</a></td><td>15,000</td></tr><tr><td>ETH-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xf1AF997ffA9b43CcA41078d74C3F897DB998e9bd">0xf1AF997ffA9b43CcA41078d74C3F897DB998e9bd</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xAEc43Fc8D4684b6A6577c3B18A1c1c6d3D55C28E">0xAEc43Fc8D4684b6A6577c3B18A1c1c6d3D55C28E</a></td><td>15,000</td></tr><tr><td>KLAY-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xf0d6Ccdd18B8A7108b901af872021109C27095bA">0xf0d6Ccdd18B8A7108b901af872021109C27095bA</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xC874f389A3F49C5331490145f77c4eFE202d72E1">0xC874f389A3F49C5331490145f77c4eFE202d72E1</a></td><td>15,000</td></tr><tr><td>MATIC-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x7970d00F24e65F1BC757896e32Db820A8e9260F0">0x7970d00F24e65F1BC757896e32Db820A8e9260F0</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x311Ec6D3a9db944aE0e92B083F1dbDe0cECcAA1C">0x311Ec6D3a9db944aE0e92B083F1dbDe0cECcAA1C</a></td><td>15,000</td></tr><tr><td>SOL-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xBd01EdC16597f68E03607ba4b941596729ec78f7">0xBd01EdC16597f68E03607ba4b941596729ec78f7</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x3C39209e85c1a27f1B992Bcf3416f5fC84764F2e">0x3C39209e85c1a27f1B992Bcf3416f5fC84764F2e</a></td><td>15,000</td></tr><tr><td>USDC-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x49e47b1149149CAEc5384427E41A387Bbc17698c">0x49e47b1149149CAEc5384427E41A387Bbc17698c</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xd46Ca83fdC20641ce2e225E930FBfb8CE8334660">0xd46Ca83fdC20641ce2e225E930FBfb8CE8334660</a></td><td>15,000</td></tr><tr><td>DAI-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x219BAD3A896964A2B28Ef4dE6Ae6E6D72B646745">0x219BAD3A896964A2B28Ef4dE6Ae6E6D72B646745</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xdE2aA055F8DA4d2a4A5063b8736C8455AEa8aB3F">0xdE2aA055F8DA4d2a4A5063b8736C8455AEa8aB3F</a></td><td>15,000</td></tr><tr><td>DOT-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x2b062807C6B3F8Ca5C366545d50aA19c114E9d7b">0x2b062807C6B3F8Ca5C366545d50aA19c114E9d7b</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x7dc55064b6ea6B75F8A73DC142707aAd0A37541c">0x7dc55064b6ea6B75F8A73DC142707aAd0A37541c</a></td><td>15,000</td></tr><tr><td>BNB-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x731A5AFB6e021579138Ea469B25C2ab46ff44199">0x731A5AFB6e021579138Ea469B25C2ab46ff44199</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xFA4CfAD7DBB1a0b3e85d0b736cf00289edDDDd5F">0xFA4CfAD7DBB1a0b3e85d0b736cf00289edDDDd5F</a></td><td>15,000</td></tr><tr><td>TRX-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xb4de9C81eaA329E1E7161E9a235D795E29eec60D">0xb4de9C81eaA329E1E7161E9a235D795E29eec60D</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x37c7Aac954e721eaBA28c58BeF496529Cde32d5f">0x37c7Aac954e721eaBA28c58BeF496529Cde32d5f</a></td><td>15,000</td></tr><tr><td>MNR-KRW</td><td><a href="https://baobab.klaytnfinder.io/account/0x22ddDb9749cB5941DdEc5fD50B12CfDdB8E259c9">0x22ddDb9749cB5941DdEc5fD50B12CfDdB8E259c9</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x6DEbE43FD00D3Dcc93D8695a3031fC8887242dee">0x6DEbE43FD00D3Dcc93D8695a3031fC8887242dee</a></td><td>15,000</td></tr><tr><td>ADA-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x70cDE6bE67486017C52215Ad5d6740ce8EaBC9b8">0x70cDE6bE67486017C52215Ad5d6740ce8EaBC9b8</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xB9C1839A40cED59Fb9e55Eb52a3B8B7E62aF1568">0xB9C1839A40cED59Fb9e55Eb52a3B8B7E62aF1568</a></td><td>15,000</td></tr><tr><td>ATOM-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xD84659b5e6d7123e21ee80f13685D733a9a9a0b0">0xD84659b5e6d7123e21ee80f13685D733a9a9a0b0</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x886703ebE4E18645B708b3fC9f528d2a9aed8D8b">0x886703ebE4E18645B708b3fC9f528d2a9aed8D8b</a></td><td>15,000</td></tr><tr><td>AVAX-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xf467B6cF8ED8c3E49c2ED5154b0Bf471c6911529">0xf467B6cF8ED8c3E49c2ED5154b0Bf471c6911529</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xeae732C571aEdB41d58Db5390D96691E6B54a580">0xeae732C571aEdB41d58Db5390D96691E6B54a580</a></td><td>15,000</td></tr><tr><td>DOGE-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x98F4BC9fE125c725423deda5418681aB7c8F2CF3">0x98F4BC9fE125c725423deda5418681aB7c8F2CF3</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x464fBa38a41526fc61Ca6Ed2C9cD7B38d822B72a">0x464fBa38a41526fc61Ca6Ed2C9cD7B38d822B72a</a></td><td>15,000</td></tr><tr><td>FTM-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x88E3CD567754A0f5068aa4053F9887e97539F764">0x88E3CD567754A0f5068aa4053F9887e97539F764</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x271ce3EB7cb9124aEaa26D18E2c448b10f2C2D21">0x271ce3EB7cb9124aEaa26D18E2c448b10f2C2D21</a></td><td>15,000</td></tr><tr><td>LTC-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x151A407169e1B594fb26F002A4c3c9fc41f1deef">0x151A407169e1B594fb26F002A4c3c9fc41f1deef</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x597a5ab68296d4dEC1296d8A96eFb3FC8b2BaE3f">0x597a5ab68296d4dEC1296d8A96eFb3FC8b2BaE3f</a></td><td>15,000</td></tr><tr><td>PAXG-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xbD07592c082A40e25a78Fd6a3d9C075B2d36BF5D">0xbD07592c082A40e25a78Fd6a3d9C075B2d36BF5D</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x555E072996d0335Ec63B448ddD507CB99379C723">0x555E072996d0335Ec63B448ddD507CB99379C723</a></td><td>15,000</td></tr><tr><td>SHIB-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0xA317038414a275365ED4a085B786E83E761d20a5">0xA317038414a275365ED4a085B786E83E761d20a5</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x51Ec645B728c6882D362677c90A6D51bb0998AD1">0x51Ec645B728c6882D362677c90A6D51bb0998AD1</a></td><td>15,000</td></tr><tr><td>UNI-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x82aC2966dD5843e718D0EaeC7108bb4778eeF66B">0x82aC2966dD5843e718D0EaeC7108bb4778eeF66B</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xa7A93c5eaabD1c458522F00a53897D5f32Da232d">0xa7A93c5eaabD1c458522F00a53897D5f32Da232d</a></td><td>15,000</td></tr><tr><td>XRP-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x92dD2d62513bC4811666C4EF27248E902e41f18c">0x92dD2d62513bC4811666C4EF27248E902e41f18c</a></td><td><a href="https://baobab.klaytnfinder.io/account/0xDcb088788722198aaED3F4F7a396558eC98cfCD0">0xDcb088788722198aaED3F4F7a396558eC98cfCD0</a></td><td>15,000</td></tr><tr><td>JOY-USDT</td><td><a href="https://baobab.klaytnfinder.io/account/0x836518342A3226479Ec448E18e1cc15ff2517362">0x836518342A3226479Ec448E18e1cc15ff2517362</a></td><td><a href="https://baobab.klaytnfinder.io/account/0x9b8B4Ea7c3934E278430fa9F9b83466fE9387a19">0x9b8B4Ea7c3934E278430fa9F9b83466fE9387a19</a></td><td>15,000</td></tr></tbody></table>

### Supported Data Feed Routers

- Baobab: <a href="https://baobab.klaytnfinder.io/account/0xAF821aaaEdeF65b3bC1668c0b910c5b763dF6354">0xAF821aaaEdeF65b3bC1668c0b910c5b763dF6354</a>
- Cypress: <a href="https://www.klaytnfinder.io/account/0x16937CFc59A8Cd126Dc70A75A4bd3b78f690C861">0x16937CFc59A8Cd126Dc70A75A4bd3b78f690C861</a>

## Architecture

데이터 피드의 온체인 구현은 [`Aggregator`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/Aggregator.sol) 와 [`AggregatorProxy`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/AggregatorProxy.sol) 두 개의 스마트 계약으로 구성됩니다. 처음에는 `Aggregator` 와 `AggregatorProxy` 가 함께 쌍으로 배포되어 단일 데이터 피드 (예: 서울의 온도 또는 BTC/USD의 가격)를 나타냅니다. `Aggregator` 는 오프체인 오라클에 의해 정기적으로 업데이트되며, and `AggregatorProxy` 는 `Aggregator` 에 제출된 데이터에 액세스하는 데 사용됩니다. 배포된 `AggregatorProxy` 계약은 데이터 피드에서 읽기 위한 일관된 API를 제공하며, `Aggregator` 계약은 더 최신 버전으로 대체될 수 있습니다.

나머지 페이지에서는 [데이터 피드에서 읽는 방법](data-feed.md#how-to-read-from-data-feed) 에 중점을 두고 [`Aggregator` 와 `AggregatorProxy` 간의 관계](data-feed.md#relation-between-aggregatorproxy-and-aggregator) 를 설명하겠습니다.

## How to read from data feed?

이 섹션에서는 Orakl Network 데이터 피드를 스마트 계약에 통합하여 어떤 데이터 피드에서든 읽을 수 있는 방법을 설명합니다. 또한 발생할 수 있는 잠재적인 문제점과 해결 방법에 대해서도 언급할 예정입니다.

이 섹션은 다음과 같은 주제로 구성됩니다:

- [Initialization](data-feed.md#initialization)
- [Read Data](data-feed.md#read-data)
- [Process Data](data-feed.md#process-data)

### Initialization

데이터 피드에 대한 액세스는 선택한 데이터 피드에 해당하는 `AggregatorProxy` 주소 및 [`@bisonai/orakl-contracts`](https://www.npmjs.com/package/@bisonai/orakl-contracts) 의 [`IAggregator`](https://github.com/Bisonai/orakl/blob/master/contracts/src/v0.1/interfaces/IAggregator.sol) 를 통해 제공됩니다.

```solidity
import { IAggregator } from "@bisonai/orakl-contracts/src/v0.1/interfaces/IAggregator.sol";

contract DataFeedConsumer {
    IAggregator internal dataFeed;
    constructor(address aggregatorProxy) {
        dataFeed = IAggregator(aggregatorProxy);
    }
}
```

### Read Data

데이터는 `latestRoundData()` 와 `getRoundData(roundId)` 함수를 사용하여 피드에서 쿼리할 수 있습니다.

`latestRoundData` 함수는 최신 제출에 대한 메타데이터를 반환합니다.

```solidity
(
   uint80 id,
    int256 answer,
    uint startedAt,
    uint updatedAt,
    uint80 answeredInRound
) = dataFeed.latestRoundData();
```

제출은 라운드로 분할되며 `id` 로 인덱싱됩니다. 노드 운영자들은 매 라운드마다 제출을 보고하고, 동일한 라운드의 모든 제출에서 집계가 계산됩니다. 이전 라운드의 제출은 `roundId`라는 추가 매개변수를 필요로 하는 `getRoundData` 함수를 통해 쿼리할 수 있습니다. 출력 형식은 `latestRoundData` 함수와 동일합니다.

```solidity
uint80 roundId =
(
    uint80 id,
    int256 answer,
    uint startedAt,
    uint updatedAt,
    uint80 answeredInRound
) = dataFeed.getRoundData(roundId);
```

### Process Data

`latestRoundData()` 및 `getRoundData(roundId)` 함수에서 반환되는 값은 해당 라운드 `id`의 데이터 피드 값 (=`answer`) 뿐만 아니라 다른 값들도 포함됩니다:

- `startedAt`
- `updatedAt`
- `answeredInRound`

`startedAt`은 라운드가 시작된 타임스탬프를 나타냅니다. `updatedAt` 은 라운드가 마지막으로 업데이트된 타임스탬프를 나타냅니다. `answeredInRound`은 답변이 계산된 라운드 `id`입니다.

> `latestRoundData()` 와 `getRoundData(roundId)` 에서 반환된 모든 메타데이터를 추적하는 것을 강력히 권장합니다. 애플리케이션이 빈번한 업데이트에 의존하는 경우, 이러한 함수 중 어느 하나로 반환된 데이터가 오래된 것이 아닌지를 애플리케이션 계층에서 확인해야 합니다.

`AggregatorProxy`에는 데이터 피드에서 반환된 `응답`을 잘못 표현하는 문제를 방지하기 위해 활용해야 하는 여러 보조 함수가 있습니다.

모든 `응답들`은 특정 소수 자릿수로 반환되며, 이 소수 자릿수는 `decimals()` 함수를 사용하여 조회할 수 있습니다.

```solidity
uint8 decimals = dataFeed.decimals();
```

`AggregatorProxy` 는 항상 하나의 `Aggregator` 에 연결되어 있지만, 이 연결은 고정되어 있지 않으며 `Aggregator` 를 변경할 수 있습니다. 동일한 `Aggregator` 를 계속 사용하고 있는지 확인하려면 `aggregator()` 함수를 통해 `Aggregator` 주소를 요청할 수 있습니다.

```solidity
address currentAggregator = dataFeed.aggregator()
```

### Use Aggregator Router

- Router Contract를 통해 편리하게 적용할 수 있습니다
- 호출함수에 가격 페어 이름(ex.BTC-USDT)을 전달하고 모든 aggregator기능에 접근해보세요

모든 피드에 접근 가능한 AggregatorRouter를 초기화합니다

```solidity
import { IAggregatorRouter } from "@bisonai/orakl-contracts/src/v0.1/interfaces/IAggregatorRouter.sol";
contract DataFeedConsumer {
    IAggregatorRouter internal router;
    constructor(address _router) {
        router = IAggregatorRouter(_router);
    }
}
```

주어진 데이터피드의 최신 데이터에 접근합니다 (ex. "BTC-USDT")

```solidity
(
   uint80 id,
    int256 answer,
    uint startedAt,
    uint updatedAt,
    uint80 answeredInRound
) = router.latestRoundData("BTC-USDT");
```

주어진 데이터피드의 특정 roundId의 가격 정보를 가져옵니다 (ex. "BTC-USDT")

```solidity
uint80 roundId =
(
    uint80 id,
    int256 answer,
    uint startedAt,
    uint updatedAt,
    uint80 answeredInRound
) = router.getRoundData("BTC-USDT", roundId);
```

주어진 데이터피드의 decimals값을 가져옵니다

```solidity
uint8 decimals = router.decimals("BTC-USDT");
```

주어진 데이터피드의 aggregator주소를 가져옵니다

```solidity
address currentAggregator = router.aggregator("BTC-USDT")
```

## Relation between `AggregatorProxy` and `Aggregator`

`AggregatorProxy` 를 배포할 때, `Aggregator`의 주소를 지정하여 계약 간에 연결을 생성해야 합니다. 그러면 컨슈머는 `latestRoundData` 또는 `getRoundData` 함수를 통해 데이터를 요청할 수 있으며, 데이터는 `aggregatorAddress`로 표시된 `Aggregator`에서 가져옵니다.

```solidity
constructor(address aggregatorAddress) {
    setAggregator(aggregatorAddress);
}
```

가끔은 `Aggregator`의 주소를 업데이트하는 것이 필요할 수 있습니다. `Aggregator` 주소가 업데이트되면 조회된 데이터 피드는 이전과 다른 `Aggregator`에서 가져옵니다. `AggregatorProxy`의 `Aggregator` 업데이트는 제안 단계와 확인 단계로 나누어집니다. 두 단계 모두 `onlyOwner` 권한으로 실행할 수 있습니다.

`proposeAggregator` 함수는 제안된 주소를 저장하는 저장소 변수에 저장하고, 새로운 주소에 대한 이벤트를 발생시킵니다.

```solidity
 function proposeAggregator(address aggregatorAddress) external onlyOwner {
     sProposedAggregator = AggregatorProxyInterface(aggregatorAddress);
     emit AggregatorProposed(address(sCurrentPhase.aggregator), aggregatorAddress);
 }
```

새로운 `Aggregator`가 제안된 후에는, `proposedLatestRoundData` , `proposedGetRoundData`와 같은 특수한 함수를 통해 새로운 데이터 피드를 조회하실 수 있습니다. 이 함수들은 새롭게 제안된 `Aggregator`를 수락하기 전에 새로운 데이터 피드를 테스트하는 데 유용합니다.

`confirmAggregator` 함수는 새롭게 제안된 `Aggregator` 로의 전환을 확정하기 위해 사용되며, `onlyOwner` 권한을 가진 계정에서만 실행할 수 있습니다. 새로운 Aggregator는 `setAggregator`를 통해 확정됩니다 (`AggregatorProxy`의 `constructor` 내에서도 호출됩니다). 마지막으로, 새로운 Aggregator는 발생한 이벤트를 통해 공지됩니다.

```solidity
function confirmAggregator(address aggregatorAddress) external onlyOwner {
    require(aggregatorAddress == address(sProposedAggregator), "Invalid proposed aggregator");
    address previousAggregator = address(sCurrentPhase.aggregator);
    delete sProposedAggregator;
    setAggregator(aggregatorAddress);
    emit AggregatorConfirmed(previousAggregator, aggregatorAddress);
}
```

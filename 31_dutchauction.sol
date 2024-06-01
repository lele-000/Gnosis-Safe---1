// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DutchAuction is Ownable,ERC721 {
    uint256 public constant COLLECTION_SIZE = 10000; // nft总数
    uint256 public constant AUCTION_START_PRICE = 1 ether; // 起拍价
    uint256 public constant AUCTION_END_PRICE = 0.1 ether; // 结束价
    uint256 public constant AUCTION_TIME = 10 minutes; // 拍卖时间
    uint256 public constant AUCTION_DROP_INTERVAL = 1 minutes; // 价格衰减时间
    uint256 public constant AUCTION_DROP_PER_STEP =
        (AUCTION_START_PRICE - AUCTION_END_PRICE)/
        (AUCTION_TIME/AUCTION_DROP_INTERVAL); // 每次衰减价格
    uint256 public auctionStratTime; // 拍卖开始时间戳
    string private _baseTokenURI; // metadata URI
    uint256[] private _allTokens; // 记录所有的tokenID

    constructor () ERC721("WTF DUTCH AUCTION","WTF DUTCH AUCTION") Ownable(address(this)) {
        auctionStratTime = block.timestamp;
    }

    function setAuctionStartTime(uint32 timestamp) external onlyOwner {
        auctionStratTime = timestamp;
    }

    function getAuctionPrice() public view returns(uint256) {
        if (block.timestamp < auctionStratTime) {
            return AUCTION_START_PRICE;
        } else if (block.timestamp - auctionStratTime > AUCTION_TIME) {
            return AUCTION_END_PRICE;
        } else {
            uint256 step = (block.timestamp - auctionStratTime)/AUCTION_DROP_INTERVAL;
            return AUCTION_START_PRICE - (step * AUCTION_DROP_PER_STEP);
        }
    }
 
    function auctionMint(uint256 quantity) external payable {
        uint256 _saleStartTime = uint256(auctionStratTime);
        // 检查拍卖是否开始
        require (_saleStartTime != 0 && block.timestamp > _saleStartTime,"sale has not start yet");
        // 检查数量够不够
        require(totalSupply() + quantity < COLLECTION_SIZE,"not enough");

        uint256 totalCost = getAuctionPrice() * quantity; //计算mint成本
        require(msg.value >= totalCost,"need more ETH"); // 检查是否发来足够eth

        // Mint NFT
        for(uint256 i = 0; i < quantity; i++) {
            uint256 mintIndex = totalSupply();
            _mint(msg.sender, mintIndex);
            _addTokenToAllTokensEnumeration(mintIndex);
        }
        // 多余ETH退款
        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost); //注意一下这里是否有重入的风险
        }
    }
     // 提款函数，onlyOwner
    function withdrawMoney() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}(""); // call函数的调用方式详见第22讲
        require(success, "Transfer failed.");
    }


    }

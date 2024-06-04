// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTSwap is IERC721Receiver {
    event List(address indexed seller, address indexed nftAddr, uint256 indexed tokenId, uint256 price);
    event Purchase(address indexed buyer, address indexed nftAddr, uint256 indexed tokenId, uint256 price);
    event Revoke(address indexed seller, address indexed nftAddr, uint256 indexed tokenId);
    event Update(address indexed seller, address indexed nftAddr, uint256 indexed tokenId, uint256 newPrice);

    // nft订单抽象为Order结构体
    struct Order {
        address owner;
        uint256 price;
    }
    // Order映射
    mapping (address => mapping (uint256 => Order)) public nftList;

    fallback() external payable { } 
    receive() external payable { }  

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns(bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    // 卖家挂单
    function list(address _nftAddr, uint256 _tokenId, uint256 _price) public {
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.getApproved(_tokenId) == address(this),"need approval");//获取授权
        require(_price > 0);

        Order storage _order = nftList[_nftAddr][_tokenId]; // 设置持有人和价格
        _order.owner = msg.sender;
        _order.price = _price;

        // 将NFT转账到合约
        _nft.safeTransferFrom(msg.sender, address(this), _tokenId);

        emit List(msg.sender, _nftAddr, _tokenId, _price);
    }

    // 卖家撤单
    function revoke(address _nftAddr, uint256 _tokenId) public {
        Order storage _order = nftList[_nftAddr][_tokenId];// 取得Order
        require(msg.sender == _order.owner,"not owner");
        // 声明IERC721接口合约变量
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order");

        // 将nft还给卖家
        _nft.safeTransferFrom(address(this), msg.sender, _tokenId);
        delete nftList[_nftAddr][_tokenId];
        emit Revoke(msg.sender, _nftAddr, _tokenId);
    }

    // 修改价格（单位为wei）
    function update(address _nftAddr, uint256 _tokenId, uint256 _newPrice) public {
        require(_newPrice > 0, "Invalid price");
        Order storage _order = nftList[_nftAddr][_tokenId];
        require(_order.owner == msg.sender, "not owner");
        // 声明IERC721接口变量
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_tokenId) == address(this),"Invalid Order");//nft在合约中

        _order.price = _newPrice; // 更新价格
        emit Update(msg.sender, _nftAddr, _tokenId, _newPrice);
    }

    // 买卖购买
    function purchase(address _nftAddr, uint256 _tokenId) payable public {
        Order storage _order = nftList[_nftAddr][_tokenId]; //取得order
        require(_order.price > 0, "invalid price");
        require(msg.value >= _order.price,"increase price");
        // 声明IERC72接口合约变量
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_tokenId) == address(this),"invalid order");
        _nft.safeTransferFrom(address(this),msg.sender,_tokenId);
        // 将eth转给卖家，将多余的eth转给买家
        payable(_order.owner).transfer(_order.price);
        payable(msg.sender).transfer(msg.value - _order.price);

        delete nftList[_nftAddr][_tokenId];
        emit Purchase(msg.sender, _nftAddr, _tokenId, _order.price);
    }
}
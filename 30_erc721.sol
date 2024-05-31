// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// 通过ERC165，智能合约可以声明他支持的接口，以供其他合约检查
// IERC165合约只声明了一个supportsInterface函数

// ERC721接受者接口：IERC721Receiver，合约必须实现这个接口才能接收NFT

contract WTFape is ERC721 {
    uint public MAX_APES = 10000;

    constructor (string memory _name, string memory _symbol) ERC721(_name,_symbol) {}

    function _baseURL() internal pure returns(string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    function mint(address to, uint tokenId) external {
        require(tokenId > 0 && tokenId <= MAX_APES, "tokenId out of range");
        _mint(to,tokenId);
    }
}
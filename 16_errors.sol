// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Errors {
    // 定义一个error
    error TransferNotOwner(address sender);

    mapping (uint256 => address) _owners;

    function transferOwner1(uint256 tokenId,address _newOwner) public {
        if(_owners[tokenId] != msg.sender){
            revert TransferNotOwner(msg.sender);
        }
        _owners[tokenId] = _newOwner;
    } 

    // require 0.8版本之前抛出异常常用方法
// gas随描述字符串长度增加而增加
function transferOwner2(uint256 tokenId, address newOwner) public {
    require(_owners[tokenId] == msg.sender, "Transfer Not Owner");
    // 条件不成立时抛出异常
    _owners[tokenId] = newOwner;
}

// assert
function transferOwner3(uint256 tokenId, address newOwner) public {
    assert(_owners[tokenId] == msg.sender);
    _owners[tokenId] = newOwner;
}
}


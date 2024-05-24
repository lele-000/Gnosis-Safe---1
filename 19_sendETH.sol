// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract ReceiveETH {
    event Log(uint256 value, uint256 gasLeft);
    receive() external payable {
        emit Log(msg.value, gasleft());
    }
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}

contract SendETH {
    constructor()payable {}
    receive() external payable { }

    // transfer方法，转账失败会revert
    function transferETH(address payable _to,uint256 amount) external payable {
        _to.transfer(amount);
    }

    // send方法，转账失败不会revert,返回值使bool,几乎没人用
    error SendFailed();
    function sendETH(address payable _to, uint256 amount) external payable {
        bool success = _to.send(amount);
        if (!success){
            revert SendFailed();
        }
    }

    // call方法，没有gas限制，允许receive(),fallback()中有复杂操作，失败不会revert
    // 返回值是(bool,bytes)
    error CallFailed();
    function callETH(address payable _to,uint256 amount) external payable {
        (bool success,) = _to.call{value: amount}("");//捕获第一个返回值，忽略其他
        if(!success) {
            revert CallFailed();
        } 
    }
}
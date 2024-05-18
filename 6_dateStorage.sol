// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract dateStorage {
    function fCalldate(uint[3] calldata _x) public pure returns(uint[3] calldata) {
        return  _x;
    }

    uint[] x = [1,2,3];
    function fStorage() public {
        uint[] storage xStorage = x;
        xStorage[0] = 100; 
    }

    //状态变量声明在合约内函数外
    //局部变量在函数内声明
    //全局变量可以不声明直接使用
    function globevar() external view returns(address,uint,bytes memory) {
        address sender = msg.sender;
        uint blockNum = block.number;
        bytes memory date = msg.data;
        return (sender,blockNum,date);
    }
}
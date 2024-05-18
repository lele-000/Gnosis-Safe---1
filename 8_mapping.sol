// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Mapping {
    // key只能是solidity内置类型，而value可以是自定义类型
    // 储存位置必须是storage
    // mapping记录的是一种关系，不能用于public函数的参数或返回值

    mapping (uint => address) public idToAddress;
    mapping (address => address) public addressToAddress;

    function writeMap(uint _Key, address _Value) public {
        idToAddress[_Key] = _Value;
    }

}
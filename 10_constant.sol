// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Constant {
    // constant,immutable 状态变量声明这两个关键字后不能更改其值
    // 数值变量可以声明这两个关键字，string，bytes可以声明constant但是不能声明immutable

    uint256 public  constant CONSTANT_NUM = 10;
    uint16 public  immutable IMMUTABLE_NUM = 88;
    string public  constant CONSTNANT_STRING = "hello";
    bytes public  constant CONSTANT_BYTES = "world";
    address public  constant CONSTANT_ADDRESS = 0x0000000000000000000000000000000000000000;

    // constant必须在声明时初始化
    // immutable可以在声明或构造函数中初始化
    address public  immutable IMMUTABLE_ADDRESS;
    uint public  immutable IMMUTABLE_N = test();
    constructor() {
        IMMUTABLE_ADDRESS = address(this);
    }
    function test() internal pure returns(uint) {
        return 9;
    }
}
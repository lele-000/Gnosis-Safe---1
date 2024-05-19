// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract initValue {
    // 所有变量都有其初始值
    // bool:false
    // string: ""
    // uint: 0

    // delete操作符会让变量变为初始值
    bool a = true;
    function deleteA() external returns(bool) {
        delete a;
        return a;
    }

}
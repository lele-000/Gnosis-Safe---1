// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Overloading {
    //允许函数重载，名字相同参数类型不同的函数可以同时存在，视为不同函数
    //不允许修饰器重载
    function saysomthing() public pure returns(string memory) {
        return "nothing";
    }
    function saysomthing(string memory _somthing) public pure returns(string memory) {
        return _somthing;
    }

    // 实参匹配
    // 调用重载函数时传入的实参会于形参做匹配，如果匹配到多个重载函数会报错

    function f(uint8 n) public pure {}
    function f(uint256 n) public pure {}
}
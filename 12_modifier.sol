// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Modifier {
    // constructor构造函数，每个合约可以有一个，在合约部署时自动执行一次
    // 他可以用来初始化合约的一些参数
    address public  owner;
    constructor(address initialOwner) {
        owner = initialOwner;
    }

    // modifier的主要使用场景时运行函数前的检查
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // 修饰器可以有参数也可以没有参数

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner; // 只有owner地址可以运行这个函数并改变owner
        // 这是常用的控制合约权限的方法
    }


}
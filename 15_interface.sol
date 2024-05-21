// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 抽象合约
abstract contract InsertionSort {
    // 如果一个合约内至少包含一个未实现的函数，合约必须被标记为abstract
    // 未实现的函数需要加virtual
    function insertionSort(uint[] memory a) public pure virtual returns(uint[] memory);
}

// 接口
// 接口类似于抽象合约，但他不能实现任何东西
// 1.不能包含状态变量
// 2.不能包含构造函数
// 3.不能继承除接口外的其他合约
// 4.所有函数必须是external，且不能有函数体
// 5.继承接口的非抽象合约必须实现接口定义的所有功能

// 接口是智能合约的骨架，定义了合约的功能以及如何触发他们

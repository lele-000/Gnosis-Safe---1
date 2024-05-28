// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 当我们调用智能合约时，本质上是向合约发送了一段calldata
// 发送的calldata中前四个字节是selector
// calldata就是告诉智能合约我要调用哪个函数以参数是什么

// msg.data是一个全局变量，值为calldata,即调用函数时传入的数据
contract Selector {
    event Log(bytes date);
    function mint(address to) public {
        emit Log(msg.data);
    }


// method id 定义为函数签名的keccak哈希后的前四个字节
// 当selector与method id相匹配时即调用该函数
// 函数签名就是 函数名(参数) mint(address)
function mintSelector() public pure returns(bytes4) {
    return bytes4(keccak256("mint(address)"));
}

// 函数的参数类型主要分为：基础类型参数，固定长度类型参数，可变长度类型参数和映射类型参数。
// 映射类型参数：contract，struct，enum 需要将该类型转换为ABI类型

// 使用selector
function callWithSignature() public {
    address(this).call(abi.encodeWithSelector(0x6a627842, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));
}
}
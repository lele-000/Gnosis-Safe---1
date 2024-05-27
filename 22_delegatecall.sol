// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// delegatecall与call类似是solidity中的低级成员函数
// 当用户A通过合约B来call合约C的时候，执行的是合约C的函数，上下文是B，msg.sender是合约B的地址，产生的效果作用在合约C
// 当用户A通过合约B来delegatecall合约C的时候，执行的是合约C的函数，上下文是B，msg.sender是合约A的地址，产生的效果作用在合约B
// delegatecall在调用合约时可以指定交易的gas，但不指定发送的eth
// 应用场景，1.代理合约，将合约的存储合约和逻辑合约分开 2.EIP-2535-Diamonds

contract C {
    // 变量必须为uint256
    uint256 public num;
    address public sender;
    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
    }
}
// 合约B与合约C的变量存储必须相同
contract B {
    uint256 public num;
    address public sender;

    function setVarsCall(address _addr, uint256 _n) public payable {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)", _n)
        );
    }
    function setVarsDelegatecall(address _addr, uint256 _n) public payable {
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _n)
        );
    }
}
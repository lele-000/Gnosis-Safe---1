// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// selfdestruct转移合约中剩余的eth
// selfdestruct(address);参数是接收合约中剩余eth的地址
// 不需要有fallback或receive也能接收
// 坎昆升级后使用此方法只转走余额，不销毁合约，合约还能调用
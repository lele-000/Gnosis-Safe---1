// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Event {
    mapping (address => uint256) public _blances;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) external {
        _blances[from] = 1000000;
        _blances[from] -= amount;
        _blances[to] += amount;
        emit Transfer(from, to, amount); 
    }
}
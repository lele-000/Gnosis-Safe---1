// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// 写一个ERC20，将IERC20规定的函数简单实现

contract ERC20 is IERC20 {
    mapping (address => uint256) public override balanceOf;
    mapping (address => mapping (address => uint256)) public override allowance;

    uint256 public override totalSupply;

    string public name;
    string public symbol;

    uint8 public decimals = 18;

    constructor (string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function transfer(address recipient, uint256 amount) public override returns(bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    } 

    function approve (address spender, uint256 amount) public override returns(bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns(bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    //mint函数，burn函数不在IERC20标准中
    function mint(uint256 amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }
    function burn(uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    } 
}
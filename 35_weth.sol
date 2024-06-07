// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// WETH (wrapped ETH) ETH的包装版本
// ETH本身不符合ERC20，包装后的ETH符合ERC20标准

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
    event Deposit(address indexed dst, uint wad);
    event Withdrawal(address indexed src, uint wad);

    constructor() ERC20("WTH","WTH"){}

    fallback() external payable { deposit(); }
    receive() external payable { deposit(); }

    function deposit() public payable  {
        _mint(msg.sender, msg.value);
        emit  Deposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) public {
        require(balanceOf(msg.sender) >= amount);
        _burn(msg.sender,amount);
        payable(msg.sender).transfer(amount);
        emit  Withdrawal(msg.sender, amount);
    }
}
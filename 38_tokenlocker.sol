// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenLocker {
    event TokenLockerStart(address indexed beneficary, address indexed token, uint256 startTime, uint256 lockTime);
    event Release(address indexed beneficary, address indexed  token, uint256 releaseTime, uint256 amount);
    IERC20 public immutable token;
    address public immutable beneficary;
    uint256 public immutable startTime;
    uint256 public immutable lockTime;

    constructor(IERC20 _token, address _beneficary, uint256 _lockTime) {
        require(lockTime > 0,"lock time should greater than 0");
        token = _token;
        beneficary = _beneficary;
        startTime = block.timestamp;
        lockTime = _lockTime;
        emit TokenLockerStart(beneficary, address(token), startTime, lockTime);
    }

    function release() public {
        require(block.timestamp >= startTime + lockTime,"TokenLock:current time is before release time");
        uint256 amount = token.balanceOf(address(this));
        require(amount > 0,"no token to release");
        token.transfer(beneficary,amount);
        emit Release(beneficary, address(token), block.timestamp, amount);
    }
}
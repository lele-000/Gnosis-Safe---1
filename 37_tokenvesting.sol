// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// 线性释放指的是代币在归属期内匀速释放
/*
项目方规定线性释放的起始时间、归属期和受益人。
项目方将锁仓的ERC20代币转账给TokenVesting合约。
受益人可以调用release函数，从合约中取出释放的代币。
*/

contract TokenVesting {
    event ERC20Released(address indexed token, uint256 indexed amount);
    mapping (address token => uint256 amount) public erc20Released;//代币地址到释放数量的映射
    address public immutable beneficiary; //受益人地址
    uint256 public immutable start; // 起始时间戳
    uint256 public immutable duration; //归属期

    constructor(address beneficiaryAddress, uint256 durationSeconds) {
        require(beneficiaryAddress != address(0),"beneficaryAddress is zero address");
        beneficiary = beneficiaryAddress;
        start = block.timestamp;
        duration = durationSeconds;
    }

    function release(address token) public {
        uint256 releasable = vestedAmount(token,uint256(block.timestamp)) - erc20Released[token];
        erc20Released[token] += releasable;
        emit ERC20Released(token, releasable);
        IERC20(token).transfer(beneficiary,releasable);
    }

    function vestedAmount(address token,uint256 timestamp) public view returns(uint256) {
        uint256 totalAllcation = IERC20(token).balanceOf(address(this)) + erc20Released[token];
        if(timestamp < start){
            return 0;
        }else if(timestamp > start + duration) {
            return totalAllcation;
        } else {
            return (totalAllcation * timestamp - start) / duration;
        }
    }

}
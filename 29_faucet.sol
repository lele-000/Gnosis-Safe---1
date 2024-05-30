// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./W_erc20.sol";

contract Faucet {
    uint256 public amountAllowed = 100; // 每次领100个代币
    address public tokenContract; // token合约地址
    mapping (address => bool) requestedAddress; // 记录领取过的地址

    // SendToken事件记录每次代币领取的地址和数量
    event SendToken (address indexed Receiver, uint256 indexed Amount);

    constructor (address _tokenContract) {
        tokenContract = _tokenContract;
    }

    function requestToken() external {
        require(!requestedAddress[msg.sender],"Can't request multimple time");
        IERC20 token = IERC20(tokenContract);
        require(token.balanceOf(address(this)) >= amountAllowed,"Faucet empty");

        token.transfer(msg.sender, amountAllowed);
        requestedAddress[msg.sender] = true;
        emit SendToken(msg.sender, amountAllowed);
    }
}
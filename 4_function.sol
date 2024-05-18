// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Function {
    uint16 public number = 1;

    function add() public {
        number++;
    }
 
    function addview() external view returns (uint16 new_num) {
        new_num = number + 1;
    }

    function addpure(uint16 _number) external pure returns (uint16 pure_num) {
        pure_num = _number + 1;
    }

    function pay() external payable returns(uint256 balance) {
        balance = address(this).balance;
    }
}
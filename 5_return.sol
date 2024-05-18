// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Return {
    function returnmultiple() public pure returns(uint256,bool,uint256[3] memory) {
        return (1,true,[uint(1),2,3]);
    }

    function returnNamed() public  pure returns(uint256 _number,bool _bool,uint256[3] memory _array) {
        _number = 1;
        _bool = true;
        _array = [uint256(1),2,3];
    }

    function readRetuen() public pure{
        uint256 _number;
    bool _bool;
    uint256[3] memory _array;
    (_number,_bool,_array) = returnNamed();
    }
}
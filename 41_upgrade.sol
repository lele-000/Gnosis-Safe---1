// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract SimpleUrgrade {
    address public implementation;
    address public admin;
    string public words;

    constructor(address implementation_) {
        implementation = implementation_;
        admin = msg.sender;
    }

    fallback() external payable { 
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    function upgrade(address newImplementation) external {
        require(msg.sender == admin,"not admin");
        implementation = newImplementation;
    }
}
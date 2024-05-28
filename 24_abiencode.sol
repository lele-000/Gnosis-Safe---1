// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// ABI是与以太坊智能合约交互的标准
// 编码后不包含类型信息，解码时需注明

contract Encode {
    uint x = 10;
    address addr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    string name = "0xAA";
    uint[2] array = [5,6];

    function encode() public view returns(bytes memory result) {
        // encode他将每个参数填充为32字节的数据，并拼接在一起
        result = abi.encode(x,addr,name,array);
    }

    function encodepacked() public view returns(bytes memory result) {
        // 类似于encode，但会把其中填充的很多0省略
        result = abi.encodePacked(x,addr,name,array);
    }

    function encodewithsignature() public view returns(bytes memory result) {
        // 第一个参数为签名函数，当调用其他合约时使用
        result = abi.encodeWithSignature("foo(uint256,address,string,uint256[2])", x,addr,name,array);
    }

    function encodewithselector() public view returns(bytes memory result) {
        result = abi.encodeWithSelector(bytes4(keccak256("foo(uint256,address,string,uint256[2])")), x,addr,name,array);
    }

    // 解码
    function decode(bytes memory data) public pure returns(uint dx, address daddr, string memory dname, uint[2] memory darray) {
        (dx, daddr, dname, darray) = abi.decode(data, (uint,address,string,uint[2]));
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// call是address类型的低级成员函数，返回值为(bool,bytes memeory)，对应是否成功及目标值的返回值
// call是官方推荐用来触发fallback和receive函数发送eth的方法
// 不推荐用call来调用另一个合约
// 如果call了不存在的函数，call仍能执行成功，并返回success，但其实调用的是fallback函数

// 目标合约地址.call(字节码)
// 字节码利用结构化编码函数abi.encodeWithSignature
contract OtherContract {
    fallback() external payable { }
    receive() external payable { }
    uint256 private x = 0;
    event Log(uint amount, uint gas);
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    function setX(uint _x) public payable {
        x = _x;
        if(msg.value != 0){
            emit Log(msg.value,gasleft());
        }
    }
    function getX() public view returns(uint) {
        return x;
    }   
 }

 contract Call {
    event Response(bool success, bytes data);
    function callSetX(address _addr,uint _x) public payable {
        (bool success, bytes memory data) = _addr.call{value:msg.value}(
            abi.encodeWithSignature("setX(uint)", _x)
        );
        emit Response(success, data);
    }
    function callGetX(address _addr) external returns(uint){
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()")
        );
        emit Response(success, data);
        return abi.decode(data, (uint));
    }
 }
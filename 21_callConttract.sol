// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract OtherContract {
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

 contract CallContract {
    function callSetX(address _address,uint _x) external {
        OtherContract(_address).setX(_x);
    }
    function callGetX(OtherContract _address) external view returns(uint) {
       return _address.getX();
    }
    function callGetX2(address _address) external view returns(uint) {
        OtherContract oc = OtherContract(_address);
        return oc.getX();
    }
 }
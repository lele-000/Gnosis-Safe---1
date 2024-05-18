// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract ArrayAndStruct {
    // 固定长度array
    uint[3] array1;
    bytes[4] array2;
    address[5] array3;

    // 可变长度array
    uint[] array4;
    bytes1 array5;
    // bytes 比 bytes1[]更省gas

    //内存数组(动态数组)只能在函数内声明
    function newarray() external pure  returns(uint,uint[] memory) {
        uint[] memory array6 = new uint[](8);
        bytes memory array7 = new bytes(9);
        array7[0] = 'y';
        array6[0] = 111;
        //动态数组只能一个一个元素的赋值
        return (array6.length,array6);
    }

    function f() external pure {
        g([uint(1),2,3]);
        //默认时uint8，必须使用uint()转换类型
    }
    function g(uint[3] memory) internal pure {
        
    }
    
    function arrayPush() public returns(uint[] memory) {
        uint[2] memory a = [uint(1),2];//而不是 uint[] memory a = new uint[uint(1),2](2);。后者是无效的语法。
        array4 = a;
        array4.push(3);
        return array4;
    }

    // struct 结构体
    struct Student {
        uint256 id;
        uint256 score;
    }
    Student public student;
    function initStudent1() external returns(Student memory) {
        Student storage _student = student;
        _student.id = 1;
        _student.score = 66;
        return student;
    }
    function initStudent2() external returns(Student memory) {
        student.id = 2;
        student.score = 77;
        return student;
    }
    function initStudent3() external returns(Student memory) {
        student = Student(3,90);
        return student;
    }
    function initStudent4() external returns(Student memory) {
        student = Student({id:4,score:99});
        return student;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Yeye {
    event Log(string msg);
    function hip() public virtual {
        emit Log("yeye");
    }
    function pop() public virtual {
        emit Log("yeye");
    }
    function yeye() public virtual {
        emit Log("yeye");
    }
}

// 简单继承
contract Baba is Yeye {
    function hip() public virtual override {
        emit Log("baba");
    }
    function pop() public virtual override {
        emit Log("baba");
    }
    function baba() public virtual {
        emit Log("baba");
    }
}

// 多重继承
// 继承时按辈分从高到低排序
// 如果某个合约在多个继承的合约里都存在，在子合约里必须重写
// 重写在多个父合约中都存在的函数时，override关键字后面要加上所有父合约的名字
contract Erzi is Yeye,Baba {
    function hip() public override (Yeye,Baba) {
        emit Log("Erzi");
    }
    function pop() public override (Yeye,Baba) {
        emit Log("Erzi");
    }

    // 子合约调用父合约中的函数
    // 1.直接调用
    function callParent() public {
        Baba.baba();
    }
    // 2.使用supper关键字调用离子合约最近的父合约函数
    function callParentSuper() public {
        super.baba();
    }
}

// 修饰器继承
contract base1 {
    modifier exactDevidedBy2To3(uint _a) virtual  {
        require(_a % 2 == 0 && _a % 3 == 0);
        _;
    }
}

contract Identifier is base1 {
    // 子合约中可以直接使用父合约中的修饰器
    function getExactDevidedBy2To3(uint _devidend) public exactDevidedBy2To3(_devidend) pure returns(uint,uint) {
        return  getExactDevidedBy2To3WithoutModifier(_devidend);
    }
    function getExactDevidedBy2To3WithoutModifier(uint _devidend) public pure returns(uint,uint) {
        uint div2 = _devidend / 2;
        uint div3 = _devidend / 3;
        return (div2,div3);
    }
    
    // 也可以在合约中重写modifier
}

// 构造函数的继承
abstract contract A { // 抽象合约，不能被实例，用于定义接口或基本合约
    uint public  a;
    constructor(uint _a) {
        a = _a;
    }
}
// 两种继承方式
// 1.在继承时声明父构造函数的参数
// 2.在在子合约构造函数中声明构造函数的参数
contract B is A(1) { // 直接将1传入构造函数

}
contract C is A {
    constructor (uint _c) A(_c * _c) { // 在合约部署时传入_c，_c作为参数传给A构造函数
                            // 并且乘了一下
    }
}

// 钻石继承
/* 继承树：
  God
 /  \
Adam Eve
 \  /
people
*/

contract God {
    event Log(string message);
    function foo() public virtual {
        emit Log("God.foo called");
    }
    function bar() public virtual {
        emit Log("God.bar called");
    }
}
contract Adam is God {
    function foo() public virtual override {
        emit Log("Adam.foo called");
        super.foo();
    }
    function bar() public virtual override {
        emit Log("Adam.bar called");
        super.bar();
    }
}
contract Eve is God {
    function foo() public virtual override {
        emit Log("Eve.foo called");
        super.foo();
    }
    function bar() public virtual override {
        emit Log("Eve.bar called");
        super.bar();
    }
}
contract people is Adam,Eve {
    function foo() public override(Adam,Eve) {
        super.foo();
    }
    function bar() public override(Adam,Eve) {
        super.bar();
    }
    // super.bar会以此调用Eve,Adam,God,的foo函数
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// try-catch只能在external中使用或创建合约时constructor使用
/*
    try externalContract.f() {
    // call成功的情况下 运行一些代码
} catch {
    // call失败的情况下 运行一些代码
}
*/

// 可以用this.f代替externalContract.f来调用本合约的函数
// 如果调用的函数没有返回值，在try后加上returns(returnType val)
// 支持捕获特殊的异常原因

contract OnlyEven {
    constructor(uint a) {
        require(a != 0, "invalid number");
        assert(a != 1);
    }

    function onlyeven(uint256 b) external pure returns(bool success) {
        require(b % 2 == 0,"ups,");
        success = true;
    }
}

contract TryCatch {
    event SuccessEvent ();
    event CatchEvent (string message);
    event CatchByte (bytes data);

    OnlyEven even; // 声明OnlyEven合约变量

    constructor(){
        even = new OnlyEven(2);
    }

    function execute(uint amount) external returns(bool success) {
        try even.onlyeven(amount) returns(bool _success) {
            emit SuccessEvent();
            return _success = true;
        } catch Error(string memory reason) {
            emit CatchEvent(reason);
        }
    }

    function executeNew(uint a) external returns(bool success) {
        try new OnlyEven(a) returns(OnlyEven _even) {
            emit SuccessEvent();
            success = _even.onlyeven(a);
        } catch Error(string memory reason) {
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            emit CatchByte(reason);
        }
    }
}
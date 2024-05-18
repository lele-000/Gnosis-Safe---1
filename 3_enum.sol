// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract enumtest {
    enum Action {buy,hold,sell}
    Action act = Action.buy;
}
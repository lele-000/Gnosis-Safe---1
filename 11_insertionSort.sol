// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract InsertionSort {
    function ifelse(uint a) external pure returns(bool) {
        if (a == 0) {
            return false;
        }else {
            return true;
        }
    }

    function forXunHuan() external pure returns(uint) {
        uint sum = 0;
        for(uint i=0;i<=9;i++){
            sum++;
        }
        return sum;
    }

    function whileXunHuan() external pure returns(uint) {
        uint sum = 0;
        uint i = 0;
        while(i<10) {
            sum += i;
            i++;
        }
        return sum;
    }

    function doWhileXunHuan() external pure returns(uint) {
        uint sum = 0;
        uint i = 0;
        do{
            sum += i;
            i++;
        }while(i<10);
        return sum;
    }

    function ternaryTest(uint x, uint y) public pure returns(uint) {
        return x >=y ? x : y;
    }

    //另外还有continue立即进入下一个循环，break跳出循环

    //排序算法(冒泡算法)
    function insertionSort(uint[] memory arr) public pure returns(uint[] memory) {
        for(uint i = 1;i < arr.length;i++) {
            uint temp = arr[i];
            uint j = i;
            while(j >= 1 && (temp < arr[j-1])) {
                arr[j] = arr[j-1];
                j--;
            }
            arr[j] = temp;
        }
        return arr;
    }
}
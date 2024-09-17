// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract ifElse{
    function foo (uint x) public pure returns (uint){
        if (x < 10){
            return 0;
        }else if(x < 20){
            return 1;
        }else {
            return 2;
        }
    }

    function ternary(uint _x) public pure returns (uint){
        //三目运算符
        return _x < 10 ? 1: 2;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract immutabsle{
    //不可变量，类似与常量，但可以在构造函数中赋值，但赋值后不可修改
    address public immutable MY_ADDRESS;
    uint public immutable MY_UINT;

    constructor(uint _myUint){
        MY_ADDRESS = msg.sender;
        _myUint = _myUint;
    }
}
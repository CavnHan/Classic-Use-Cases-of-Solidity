// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract Variables{
    //变量
    //状态变量存储在区块链上，也就是storage中
    string public  text = "hello";
    uint public num = 123;

    function dosomething()public {
        //局部变量存储在memory中
        uint i =456;
        //下面是一些全局变量
        uint timestamp = block.timestamp;//当前块的时间戳
        address sender = msg.sender;//合约发送者地址
    }
}
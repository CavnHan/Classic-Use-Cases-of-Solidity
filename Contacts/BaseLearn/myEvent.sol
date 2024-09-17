// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract myEvent{
    //事件允许记录到eth链上，监听事件和用户交互界面
    //indexed修饰符标记的参数会被存储在日志的索引部分
    event log (address indexed sender,string message);//通过索引参数过滤日志
    event anotherLog();
    function test() public {
        emit log(msg.sender,"hello world");//emit用于触发事件
        emit anotherLog();
    }
}
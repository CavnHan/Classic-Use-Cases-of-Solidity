// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
//要写入或更新状态变量，您需要发送一个事务。

// 另一方面，您可以免费读取状态变量，无需任何交易费用。
contract simpleStrorage{
    uint public  num;//存储数字的状态变量


//需要写入事务才能修改状态变量
    function set(uint _num) public {

        num = _num;
    }

//可以从状态变量中读取而无需发送事务
    function get() public view returns (uint){
        return num;
    }
}

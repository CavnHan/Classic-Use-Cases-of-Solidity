// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract myEnum{
    //代表状态的枚举
    enum Status{
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    //这里默认值是第一个元素
    Status public status;

    // Returns uint
    // Pending  - 0
    // Shipped  - 1
    // Accepted - 2
    // Rejected - 3
    // Canceled - 4

    function get() public  view returns (Status){
        return status;
    }
    //可以通过下标进行值更新
    function set(Status _status) public {
        status = _status;
    }

    function cancle() public {
        status = Status.Canceled;
    }

    function reset() public {
        delete status;//将枚举重置为第一个值
    }
}
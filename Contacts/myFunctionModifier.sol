// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract myFunctionModifier{
    address public owner;
    uint256 public x = 10;
    bool public locked;

    constructor(){
        //将交易发送者设置为合约的所有者
        owner=msg.sender;
    }
    //检查调用者是否是合约的所有者
    modifier onlyOwner(){
        require(msg.sender == owner,"not owner !");
        _;
    }
    //检查传入的地址是否为0地址
    modifier validAddress(address _addr){
        require(_addr != address(0),"not valid address");
        _;
    }
    function changeOwner(address _newOwner) public onlyOwner validAddress(_newOwner){
        owner = _newOwner;
    }
    modifier noReentrancy(){
        require(!lockerd,no reentrancy);
        locked = true;
        _;
        locked = false;
    }

    function decrement(uint256 i) public noReentrancy{
        x -= i;
        if(i > 1) {
            decrement(i - 1);
        }
    }
}
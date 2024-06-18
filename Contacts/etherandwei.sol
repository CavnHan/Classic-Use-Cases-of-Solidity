// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract EtherUints{
    //以太币的交易
    uint public onewei = 1 wei;//wei是最小的货币单位
    //1wei 等于 1
    bool public isOneWei = (1 == onewei);

    uint public isOneGswei = 1 gwei;
    //1gwei equals to 10^9 wei
    bool public isOneGwei = (1e9 == isOneGswei);

    uint public oneEther = 1 ether;
    //1 ether is equal to 10^18 wei
    bool public isOneEther = (1e18 == oneEther);
}
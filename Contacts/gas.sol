// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract Gas{
    //每笔交易都需要消耗gas
    uint public i = 0;
    //如果交易时gas被耗尽，交易会终止并revert,但是gas不会退还
    function forever() public {
        while (true){
            i+=1;//无限消耗gas
        }
    }
}
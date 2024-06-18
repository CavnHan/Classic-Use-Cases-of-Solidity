// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract myviewandpure{
    uint256 public x =1;

//view承诺只读
    function addtox(uint256 y) public view returns (uint256){
        return x+y;
    }

    //pure承诺不读不改
    function add(uint256 i,uint256 j) public pure returns (uint256){
        return i+j;
    }
}
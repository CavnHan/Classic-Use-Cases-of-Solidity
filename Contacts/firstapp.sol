// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract counter {
    uint public count;
    //get the current count
    function get() public view returns (uint){
        return count;
    }

    //increment count by 1
    function inc () public {
        count += 1;
    }

    //decrement count by 1
    function dec() 
    public {
        //this function will fail if count = 0
        count -= 1;
    }
    
}
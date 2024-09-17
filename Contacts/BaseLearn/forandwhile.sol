// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract Loop{
    function loop() public {
        // for loop
        for(uint i =0;i<10;i++){
            if(3 == i){
                continue ;
            }
            if(5 == i) {
                break ;
            }
        }
        uint j;
        while (j < 10){
            j++;
        }
    }
}
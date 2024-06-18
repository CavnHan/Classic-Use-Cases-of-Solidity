// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract functionmy{
    function named() public pure  returns (uint256 x ,bool b ,uint256 y){
        return (1,true,2);
    }

    function assigned() public pure returns (uint256 x ,bool b,uint256 y){
        x = 1;
        b = true;
        y =2 ;
    }

//解构赋值
    function destructurinAssignments() public pure returns (uint256,bool,uint256,uint256,uint256){
        (uint256 i,bool b,uint256 j) = returnMany();
        (uint256 x,,uint256 y) = (4,5,6);
        return (i,b,j,x,y);
    }
    //mapping不能作为入参或出参，array可以
    function arrayInput(uint256[] memory _arr) public {

    }
    uint256[] public  arr;
    function arrayOUtPUt() public view  returns (uint256[] memory){
        return arr;
    }

    //使用键值输入调用函数
    contract xyz {
        function somefuncWithManyI(
            uint x,
            uint y,
            uint z,
            address a,
            bool b,
            string memory c
        )public pure returns (uint256){
        
        }
        function callfun() external pure returns (uint256){
            return somefuncWithManyI(1,2,3,address(0),true,"c");
        }

        function callfunwithkeyva() external pure returns (uint256){
            return somefuncWithManyI({
                a:address(0),
                b:true,
                c:"c",
                x:1,
                y:2,
                z:3
            });
        }
    }



}
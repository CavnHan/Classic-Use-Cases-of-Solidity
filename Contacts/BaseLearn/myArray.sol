// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract myArray{
    //初始化数组
    uint256[] public arr;
    uint256[] public  arr2 = [1,2,3];
    //固定大小的数组，所有的元素初始化值为0
    uint256[10] public myFixedSizeArr;

    function get(uint256 i) public  view returns (uint256) {
        return arr[i];
    }

    //可以返回整个数组，但应该避免使用长度无线的数组
    function getArr() public view returns (uint256[] memory){
        return  arr;
    }

    function push(uint i) public {
        //添加一个元素
        arr.push(i);
    }

    function pop() public {
        //移除最后一个元素
        arr.pop();
    }

    function getLength() public  view returns (uint){
        return arr.length;
    }

    function remove(uint index) public {
        //删除不会改变数组的长度,只是将特定索引处的元素的值重置为0
        delete arr[index];
    }

    function examples() external {
        //在内存中创建的数组，只能创建固定大小，内存数组不能在声明的时候之间赋值
        uint256[] memory a = new uint256[](5);
    }
}
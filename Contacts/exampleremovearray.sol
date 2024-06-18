// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract ArrayReoveByShifting{
    uint256[] public  arr;
    //删除指定索引位置处的元素，指定索引处后的所有元素向前移动一位，并删除最后一个元素
    function remove(uint256 _index) public {
        require(_index < arr.length,"index out of bound");
        for (uint256 i = _index ; i<arr.length-1 ; i++){
            arr[i] = arr[i+1];
        }
        arr.pop();
    }

    function test() external {
        arr = [1,2,3,4,5];
        remove(2);
        //[1,2,4,5]
         assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4);

        arr = [1];
        remove(0);
        //[]
        assert(arr.length == 0);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract InsertingSort {
    // 插入排序，返回排序后的数组

    function insertionSort(uint256[] memory array)
        public
        pure
        returns (uint256[] memory)
    {
        uint256 length = array.length;
        for (uint256 i = 1; i < length; i++) {
            uint256 key = array[i];
            int256 j = int256(i) - 1; // 将 j 转换为 int 类型以支持负数

            // 向左扫描，并找到合适的位置
            while (j >= 0 && array[uint256(j)] > key) {
                array[uint256(j + 1)] = array[uint256(j)];
                j--;
            }
            array[uint256(j + 1)] = key; // 插入 key 到合适的位置
        }
        return array; // 返回排序后的数组
    }

    // 辅助函数，用于测试排序效果
    function sortAndGetResult() public pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](5); // 初始化长度为5的数组
        array[0] = 34;
        array[1] = 8;
        array[2] = 64;
        array[3] = 51;
        array[4] = 32;

        return insertionSort(array);
    }
}

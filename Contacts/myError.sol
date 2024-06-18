// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract myError{
    //用于执行前的校验
    function testRequire(uint256 _i) public pure {
        require(_i > 10,"input must be greater than 10");
    }

    function testRevert(uint256 _b)public pure {
        //也用于校验，直接恢复
        if(_b >= 10)revert("input must be greater than 10");
    }
    uint public num;

    //assert用于测试内部错误
    function testAssert() public view {
        assert(0 == num);
    }

//可以自定义错误


error Insufficeienba(uint balance,uint wihtdrawAmount);

function testCustomer(uint256 _withdrawAmount) public view {
    uint256 bal = address(this).balance;
    if(bal < _withdrawAmount){
        revert Insufficeienba({
            balance: bal;
            _withdrawAmount: _withdrawAmount
        });
    }
}

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
这个ETH钱包有如下功能：
1.任何人都可以发送金额到合约
2.只有owner可以取款
3.3种取钱方式
*/
contract ETHWalle {
    //定义合约的所有者
    address payable public immutable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    //只有owner可以取款
    modifier onlyOwner() {
        require(owner == msg.sender, "only owner can payee");
        _;
    }

    //取款方式1 transfer
    function withDraw1(uint256 amount) external onlyOwner {
        payable(msg.sender).transfer(amount);
    }

    //取款方式2 send
    function withDraw2(uint256 amount) external onlyOwner returns (bool) {
        bool success = payable(msg.sender).send(amount);
        return success;
    }
    //取款方式3 call
    function withDraw3(uint256 amount) external  onlyOwner returns (bool) {
        (bool success,) = msg.sender.call{
            value: amount
        }("");
        return success;
    }
    function getBalance() external view returns (uint256){
        return address(this).balance;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


/**
这是一个存钱罐合约所有人都可以存钱：ETH
只有合约Owner才可以取钱
只要取钱，合约就销毁掉selfdestruct
扩展：支持主笔以外的资产：ERC20  ERC721
*/
contract Bank{

    address payable public immutable owner;

    mapping (address => uint) public tokenBalances;
    mapping (address => mapping (uint => address)) public erc721Owner;

    constructor() {
        //合约部署时记录部署者的地址
        owner = payable (msg.sender);
    }
    //记录eth余额
    event recordBalance(uint newBalance);
    //ERC20记录
    event ERC20withdraw(address indexed token,uint amount);
    //ERC721记录
    event ERC721withdraw(address indexed token,uint indexed tokenID,address indexed owner);

    modifier checkOwner{
        //检查是否为Owner
        require(msg.sender == owner,"Only the Owner can call this function");
        _;
    }
    
    //存钱函数,所有用户可以存入ETH
    function depositETH() external payable {
        //每次调用，记录一次余额
        emit recordBalance(address(this).balance);
    }

    //只有Owner可以调用，提取指定金额的ETH并销毁合约
    function withDrawETH(uint amount) external  checkOwner payable {
        //转账给所有者
        owner.transfer(amount);
        //销毁合约并将剩余的eth发送给所有者
        selfdestruct(owner);
    }

    //接收ETC20代币并更新余额
    function depositERC20(address token,uint amount) external payable {
        IERC20(token).transferFrom(msg.sender,address(this),amount);
        tokenBalances[token] += amount;
    }

    //只有Owner可以调用，提取指定ERC20代币。
    function withdrawERC20(address token,uint amount) external checkOwner payable {
        //更新余额
        tokenBalances[token] -= amount;
        //提取代币
        IERC20(token).transfer(owner,amount);
        //记录
        emit ERC20withdraw(token,amount);
    }


    //接收ERC721代币并更新所有权。
    function depositERC721(address token,uint tokenId) external payable {
        //接收代币
        IERC721(token).transferFrom(msg.sender,address(this),tokenId);
        erc721Owner[token][tokenId] = msg.sender;
        //记录
        emit ERC721withdraw(token, tokenId, owner);
    }

    //只有Owner可以调用，提取指定ERC721代币。
    function withdrawERC721(address token,uint tokenId) external checkOwner payable {
        //更新余额
        erc721Owner[token][tokenId] = address(0);
        //转移
        IERC721(token).transferFrom(address(this),owner,tokenId);
        //记录
        emit ERC721withdraw(token,tokenId,owner);
    }


}
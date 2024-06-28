// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
*这是一个众筹合约，合约分为两种角色：受益人，资助者，受益人只有一个
状态变量为：筹资目标数量    fundingGoal
//      当前募集数量    fundingAmount
//      资助者列表      funders
//      资助者人数      fundersKey
需要部署时候传入的数据:
//      受益人
//      筹资目标数量
*/
contract crowd {
    //受益人
    address public immutable beneficiary;
    //筹资目标数量
    uint256 public immutable fundingGoal;
    //资助者
    mapping(address => uint256) public funders;
    //资助者人数
    address[] public fundersKey;
    //当前募集数量
    uint256 public nowFundAmount;
    //资金是否已经募集足够
    bool public isEnough;
    //记录资助者是否已经资助
    mapping(address => bool) public isCrowds;

    constructor(address beneficiary_, uint256 fundingGoal_) {
        beneficiary = beneficiary_;
        fundingGoal = fundingGoal_;
        isEnough = false;
    }

    //募集资金
    function contribute() external payable {
        //判断资金是否已经募齐
        require(!isEnough, "Enough money has been raised");
        require(msg.value > 0, "Contribution amount must be greater than 0");
        //判断资助者是否已经资助
        if (!isCrowds[msg.sender]) {
            //第一次资助
            isCrowds[msg.sender] = true;
            //统计资助者人数
            fundersKey.push(msg.sender);
        }

        //资助者列表
        funders[msg.sender] += msg.value;
        //计入金额
        nowFundAmount += msg.value;

        //判断募集资金是否已经足够
        if (fundingGoal <= nowFundAmount) {
            isEnough = true;
        }
    }

     // 获取资助者人数
    function getFundersCount() public view returns (uint256) {
        return fundersKey.length;
    }
}

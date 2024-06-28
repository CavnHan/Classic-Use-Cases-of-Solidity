// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
/*
*weth合约用于包装eth主币，作为ERC20的合约。标准的ERC20合约包括如下几个功能
*3个查询：
*balanceOf:查询指定地址的Token数量
*allowance:查询指定地址对另一个地址的剩余授权额度
*totalSupply:查询当前合约的Token总量
*2个交易：
*transfer:从当前调用者地址发送指定数量的Token到指定地址，这是一个写入方法，所有还会抛一个Transfer事件
*transferFrom:当向另一个合约地址存款时，对方合约必须调用transferFrom才可以把Token拿到它自己的合约中
*2个事件
*Transfer
*Approval
*1个授权
*approve:授权指定地址可以操作调用者的最大Token数量
*/
contract WETH{
    //存储用户余额映射
    mapping(address => uint256) public balances;
    //指定地址对另一个地址的授权额度
    mapping(address => mapping (address => uint256)) public  allowances;
    //当前合约的token总量
    uint256 public totalAmount ;

    //Transfer事件
    event Transfer(address indexed form,address indexed to,uint256 value);
    //Approval事件
    event Approval(address indexed owner,address indexed spender,uint256 value);
    //Deposti事件
    event Deposit(address indexed owner,uint256 value);
    //WithDraw事件
    event withdraw(address indexed owner,uint256 value);

    //查询当前合约的token总量
    function totalSupply() public view   returns (uint256){
        return address(this).balance;
    }
    //查询指定地址对另一个地址的剩余授权额度
   function allowance(address giveAddress,address authAddress)public view returns (uint256) {
    return allowances[giveAddress][authAddress];
}
   //查询指定地址的token数量
   function balanceOf(address addr) public view  returns  (uint256){
    return balances[addr];
   }

   function deposit() public payable  {
    //调用者向合约存入代币
    balances[msg.sender] += msg.value;
    emit Deposit(msg.sender, msg.value);

   }
   //调用者取出指定数量的代币
   function withDraw(uint256 amount) public {
    require(balances[msg.sender] >= amount);
    balances[msg.sender] -= amount;
    //转账
    payable (msg.sender).transfer(amount);
    emit withdraw(msg.sender,amount);
   }

   //transfer:从当前调用者地址发送指定数量的Token到指定地址，这是一个写入方法，所有还会抛一个Transfer事件
   function transfer(address toAdr,uint256 amount)public returns (bool){
    return transferFrom(msg.sender,toAdr,amount);
   }
   function transferFrom(address src,address toAdr,uint256 amount) public returns (bool){
    //检查调用者的余额是否大于amount
    require(balances[src] >= amount,"caller's balance is not full");
    //判断src是否为合约的调用者
    if(src != msg.sender){
        //src委托调用者进行转账交易
        //检查授权额度是否够用
        require(allowances[src][msg.sender] >= amount);
        //减少相应额度
        allowances[src][msg.sender] -= amount;
    }
    //确保转账操作金额不为零
    require(amount > 0,"Transfer amount must be greater than zero");
    //扣除调用者余额
    balances[src] -= amount;
    //增加目标地址余额
    balances[toAdr] += amount;
    //记录
    emit Transfer(src, toAdr, amount);
    return true;
   }

   //授权指定地址可以操作调用者的最大数量
   function approve(address delegateAddr,uint256 amount) public returns (bool){
    allowances[msg.sender][delegateAddr] = amount;
    emit Approval(msg.sender,delegateAddr,amount);
    return true;
   }

   fallback() external payable {
    deposit();
    }

    receive() external payable { 
        deposit();
    }



}
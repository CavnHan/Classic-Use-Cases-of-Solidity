// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract x{
    string public name;

    constructor(string memory _name){
        name = _name;
    }

}

contract y{
    string  public text;
    constructor(string memory _text){
        text = _text;
    }
}

//合约继承调用构造函数初始化
//合约b继承x和y
contract b is x("input to x "),y("input to y"){

}

contract c is x,y{
    //在子类构造函数中传递父类参数
    constructor(string memory _name,string memory _text) x(_name) y(_text){}
}
//父构造函数总是按照继承顺序调用
contract d is x,y{
    //调用顺序：x -> y -> d
    constructor()x("x is called") y ("y was called"){}
}

// Order of constructors called:
// 1. X
// 2. Y
// 3. E
contract E is X, Y {
    constructor() Y("Y was called") X("X was called") {}
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract Mapping {
    //集合类型
    mapping (address => uint) public  myMap;//底层是一个hashtable

    function get (address _addr) public view  returns (uint){
        //如果查询的key的value不存在，会返回value类型的默认值
        return myMap[_addr];//取key对应的value
    }

    function set (address _addr,uint _i) public {
        //根据key更新value
        myMap[_addr] = _i;//更新value
    }

    function remove(address _addr,uint _i) public view returns (bool){
        //将对应key的value重置为默认值
        return delete myMap[_addr];
    }

    //mapping可以进行嵌套
    mapping (address => mapping (uint => bool)) public nested;

    function get2 (address _addr1,uint _i1) public view returns (bool){
        return nested[_addr][_i1];//进行嵌套集合的访问
    }

    function  set2(address _addr2,uint _i2,bool _boo) public {
        nested[_addr2][_i2] = _boo;
    }

    function remove(address _addr3,uint _i3)  public {

        delete nested[_add3][_i3];
    }

}